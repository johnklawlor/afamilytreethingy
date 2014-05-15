class TreeController < ApplicationController
	before_filter :signed_in_filter

	before_filter :allows_editing?, only: :edit
	before_filter :within_family, only: :show
	
	def show
		member = Member.find_by_id(params[ :id])
		oldest_ancestor = Member.find_by_id(member.oldest_ancestor)

		@family = build_tree(oldest_ancestor, oldest_ancestor.id)
		
		render layout: "tree"
	end

	def edit
		@member = Member.find_by_id(params[ :id])
	end

	private
	
		def allows_editing?
			member = Member.find_by_id( params[ :id])
		
			unless current_member?(member) || 
						( member.allows_editing? &&
							current_member.family_of?(member) ) ||
						current_member.admin?
				redirect_to member_path( current_member), flash: { error: "You do not have permissions to edit or update this member."}
			end
		end
end
