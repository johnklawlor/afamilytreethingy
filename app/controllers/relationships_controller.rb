class RelationshipsController < ApplicationController
	def create

		@member = Member.find_by_id(params[ :relationship][ :child_id])
		parent = Member.find_by_id( params[ :relationship][ :parent_id])
		@member_relationship = Relationship.new(parent_id: parent.id, child_id: @member.id)
		
		if @member_relationship.save
			if params[ :commit] == 'add parent'
				redirect_to edit_tree_path(@member)
			else
				redirect_to edit_tree_path(parent)
			end
		else
			render template: 'tree/edit'
		end

	end

	def destroy
		relationship = Relationship.find_by_id( params[ :id])
		relationship.destroy
		redirect_to edit_tree_path(params[ :member][ :id])
	end
end
