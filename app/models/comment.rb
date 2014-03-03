class Comment < ActiveRecord::Base

	has_one :update, as: :updated_by

	after_create :create_update
	before_destroy :delete_update
	
	def create_update
		post = Post.find_by_id( self.post_id)
		
		if post.comments.count > 1
			post.comments.select(:member_id).distinct.each do |commenters|
				next if self.new_record?
				member = Member.find_by_id( commenters.member_id)
				Update.where(member_id: member.id, update_on_type: 'post', update_on_id: post.id, from_member: self.member_id).each do |u|
					u.destroy
				end
				unless member.id == self.member_id
					update = member.updates.create!( from_member: self.member_id, update_on_type: 'post', update_on_id: post.id, updated_by_type: 'comment', updated_by_id: self.id)
				end
			end
		end
		if post.member_id != self.member_id
			member = Member.find_by_id( post.member_id)
			Update.where(member_id: member.id, update_on_type: 'post', update_on_id: post.id, from_member: self.member_id).each do |u|
				u.destroy
			end
			update = member.updates.create!( from_member: self.member_id, update_on_type: 'post', update_on_id: post.id, updated_by_type: 'comment', updated_by_id: self.id)
		end
	end
	
	def delete_update
		Update.where( update_on_type: 'comment', update_on_id: self.id).each do |update|
			update.destroy
		end
	end
end
