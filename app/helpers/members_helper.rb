module MembersHelper
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::UrlHelper

	def build_tree(add_member)
		children = []
		id = add_member.birthdate
		name=""
		if add_member.has_spouse?
			link = link_to(add_member.spouse.first_name, tree_path(id: add_member.spouse) )
			name = add_member.first_name + " and " + 
			link + " " +
			add_member.last_name
			edit =
			"<div class=edit>
				edit
				#{ link_to "#{add_member.first_name}'s", edit_tree_path(add_member) } or
				#{ link_to "#{add_member.spouse.first_name}'s ", edit_tree_path(add_member.spouse) }
				tree
			</div>"
		else
			name = add_member.first_name + "<br/>" + add_member.last_name
			edit = 
			"<div class=edit>
				edit 
				#{ link_to "#{add_member.first_name}'s", edit_tree_path(add_member) }
				 tree
			</div>"
		end
		
		name += edit
		
		if add_member.has_children?
			add_member.children.order('birthdate').each do |child|
				children << build_tree(child)
			end
		end
		
		return {"id" => id, "name" => name, "children" => children}
	end
	
	def update_ancestor(old, new)
		Member.where(oldest_ancestor: old).each do |m|
			m.oldest_ancestor = new
			m.save
		end
		anc = Member.find_by_id(new)
		anc.oldest_ancestor = new
		anc.save
	end
end
