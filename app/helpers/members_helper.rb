module MembersHelper
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::AssetTagHelper

	def build_tree(add_member, oldest_ancestor_id)
		children = []
		id = add_member.birthdate

		name = "<div class='image_block'>#{ image_tag( add_member.image_url( :medium), class: 'img-rounded tree_image') }"
		if add_member.has_spouse?
			name += "#{ image_tag( add_member.spouse.image_url( :medium), class: 'img-rounded tree_image') }"
		end
		# add link to switch to member's other divorced parent's tree
		if add_member.parents.count==2 && !(add_member.parents.first.spouse == add_member.parents.last)
			if add_member.parents.first.oldest_ancestor == oldest_ancestor_id
				oldest_ancestor = add_member.parents.last.oldest_ancestor
			else
				oldest_ancestor = add_member.parents.first.oldest_ancestor
			end
			name += "<div class='over_image btm'>#{ link_to( add_member.first_name, tree_path(oldest_ancestor) ) }"
		else
			name += "<div class='over_image btm'>#{add_member.first_name}"
		end
		
		# add link to switch to member's spouse's tree, if any
		if add_member.has_spouse?
			link = link_to(add_member.spouse.first_name, tree_path(add_member.spouse) )
			name += " and " + 
			link + " " +
			add_member.last_name
			# add link to edit member's and spouse's tree
			edit =
			"<div class=edit>
				edit
				#{ link_to "#{add_member.first_name}'s", edit_tree_path(add_member) } or
				#{ link_to "#{add_member.spouse.first_name}'s ", edit_tree_path(add_member.spouse) }
				tree<br/>
				view
				#{ link_to "#{add_member.first_name}'s", member_path(add_member) } or
				#{ link_to "#{add_member.spouse.first_name}'s", member_path(add_member.spouse) }
				profile
			</div></div></div>"
		else
			name += " " + add_member.last_name
			# add link to edit member's tree
			edit = 
			"<div class=edit>
				edit 
				#{ link_to "#{add_member.first_name}'s", edit_tree_path(add_member) }
				 tree<br/>
				 view
				#{ link_to "#{add_member.first_name}'s", member_path(add_member) }
				 profile
			</div></div></div>"
		end
		
		name += edit
		
		if (add_member.has_children? || (add_member.has_spouse? && add_member.spouse.has_children?))
			Member.where(id: Relationship.select('child_id').where(parent_id: [add_member, add_member.spouse_id])).order('birthdate').each do |child|
				children << build_tree(child, oldest_ancestor_id)
			end
		end
		
		return {"id" => id, "name" => name, "children" => children}
	end

	# set oldest_ancestor of member old and all of their descendants to value new
	def remove_ancestor( old, new)
		member = Member.find_by_id(old)
		member.oldest_ancestor = new
		member.save
		unless member.children.nil?
			member.descendants.each do |d|
				d.oldest_ancestor = new
				d.save
			end
		end
	end
	
	def add(spouses)
		new_spouses=[]
		spouses.each do |spouse|
			new_spouses << spouse
			new_spouses.concat( spouse.descendants_and_their_spouses)
		end
		new_spouses
	end
	
end
