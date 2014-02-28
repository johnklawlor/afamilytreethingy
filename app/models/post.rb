class Post < ActiveRecord::Base

	after_create :create_update
	before_destroy :delete_update
	
	def create_update
		to_member = Member.find_by_id( self.member_id)
		to_member.updates.create( what: 'post', what_id: self.id, commented_on_type: 'wall', commented_on_id: self.id, from_member: self.from_member) unless to_member.id = self.from_member
	end
	
	def delete_update
		update_to_delete = Update.find_by_what_id( self.id)
		update_to_delete.destroy unless update_to_delete.nil?
	end

end
