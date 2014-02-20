class Post < ActiveRecord::Base

	after_create :create_update
	
	def create_update
		to_member = Member.find_by_id( self.member_id)
		to_member.updates.create( what: 'post', what_id: self.id)
	end

end
