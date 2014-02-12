class SpouseRelationshipsController < ApplicationController
	def create
		@member = Member.find_by_id(params[ :spouse_relationship][ :member_id])
		spouse_id = params[ :spouse_relationship][ :spouse_id]
		@member_relationship = SpouseRelationship.new(member_id: @member.id, spouse_id: spouse_id)
		
		if @member_relationship.save
			redirect_to edit_tree_path(@member)
		else
			render template: 'tree/edit'
		end
	end

	def destroy
		relationship = SpouseRelationship.find_by_id( params[ :id])
		member = relationship.member_id
		
		relationship.destroy
		
		redirect_to edit_tree_path( member)
	end
end
