class Comment < ActiveRecord::Base
	include ActionView::Helpers::DateHelper

#	has_one :update, as: :updated_by

	after_create :create_update
	after_create :notify_members
	before_destroy :delete_update
	
	def notify_members
		from_whom = Member.find_by_id(member_id)
		comment = { comment: self, name: from_whom.first_name.downcase, sent_when: time_ago_in_words(self.created_at).to_s + ' ago', url: from_whom.image_url( :micro) }.to_json
		ActiveRecord::Base.connection.execute "NOTIFY #{channel}, #{ActiveRecord::Base.connection.quote comment}"
	end
	
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
		unless post.from_member == self.member_id
			member = Member.find_by_id( post.from_member)
			Update.where(member_id: member.id, update_on_type: 'post', update_on_id: post.id, from_member: self.member_id).each do |u|
				u.destroy
			end
			update = member.updates.create!( from_member: self.member_id, update_on_type: 'post', update_on_id: post.id, updated_by_type: 'comment', updated_by_id: self.id)
		end
	end
	
	def delete_update
		Update.where( updated_by_type: 'comment', updated_by_id: self.id).each do |update|
			update.destroy
		end
	end
	
	private
		def channel
			member = Post.find_by_id(self.post_id).member_id
			"new_comment_#{member}"
		end
end
