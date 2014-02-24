class Comment < ActiveRecord::Base

	after_create :create_update
	before_destroy :delete_update
	
	def create_update
		image = Image.find_by_id( self.image_id)
		
		if image.comments.count > 1
			image.comments.select(:member_id).distinct.each do |commenters|
				next if self.new_record?
				member = Member.find_by_id( commenters.member_id)
				Update.where(member_id: member.id, commented_on_type: 'image', commented_on_id: image.id, from_member: self.member_id).each do |u|
					u.destroy
				end
				member.updates.create!( what: 'comment', what_id: self.id, from_member: self.member_id, commented_on_type: 'image', commented_on_id: image.id) unless member.id == self.member_id
			end
		else
			if image.member_id != self.member_id
				member = Member.find_by_id( image.member_id)
				member.updates.create!( what: 'comment', what_id: self.id, from_member: self.member_id, commented_on_type: 'image', commented_on_id: image.id)
			end
		end
	end
	
	def delete_update
		Update.where(what_id: self.id).each do |update|
			update.destroy
		end
	end
end
