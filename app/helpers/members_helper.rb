module MembersHelper
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::UrlHelper

	def build_tree(add_member, oldest_ancestor_id)
		children = []
		id = add_member.birthdate
		
		# add link to switch to member's other parent's tree
		if add_member.parents.count==2 && !(add_member.parents.first.spouse == add_member.parents.last)
			if add_member.parents.first.oldest_ancestor == oldest_ancestor_id
				oldest_ancestor = add_member.parents.last.oldest_ancestor
			else
				oldest_ancestor = add_member.parents.first.oldest_ancestor
			end
			name = "#{ link_to( add_member.first_name, tree_path(oldest_ancestor) ) }"
		else
			name = add_member.first_name
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
				tree
			</div>"
		else
			name += "<br/>" + add_member.last_name
			# add link to edit member's tree
			edit = 
			"<div class=edit>
				edit 
				#{ link_to "#{add_member.first_name}'s", edit_tree_path(add_member) }
				 tree
			</div>"
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
	
end
