class Comment < ActiveRecord::Base
	include ActionView::Helpers::DateHelper

	after_create :create_update
	after_create :notify_members
	before_destroy :delete_update
	
	def notify_members
		from_whom = Member.find_by_id(member_id)
		comment = { comment: self, name: from_whom.first_name.downcase, sent_when: time_ago_in_words(self.created_at).to_s + ' ago', url: from_whom.image_url( :micro) }.to_json
		$redis.publish( 'comments.create', comment)
	end
	
	def create_update
		post = Post.find_by_id( self.post_id)
		
		if post.comments.count > 1
			post.comments.select(:member_id).distinct.each do |commenter|
				member = Member.find_by_id( commenter.member_id)
				Update.where(member_id: member.id, update_on_type: 'post', update_on_id: post.id, from_member: self.member_id).each do |u|
					u.destroy
				end
				unless member.id == self.member_id || member.id == post.member_id
					update = member.updates.create!( from_member: self.member_id, update_on_type: 'post', update_on_id: post.id, updated_by_type: 'comment', updated_by_id: self.id)
				end
			end
			member_who_has_post = Member.find_by_id(post.member_id)
			Update.where(member_id: member_who_has_post.id, update_on_type: 'post', update_on_id: post.id, updated_by_type: 'comment', from_member: self.member_id).each do |u|
				u.destroy
			end
			member_who_has_post.updates.create!( from_member: self.member_id, update_on_type: 'post', update_on_id: post.id, updated_by_type: 'comment', updated_by_id: self.id) unless self.member_id == post.member_id
		else
			unless post.from_member == self.member_id
				member_who_posted = Member.find_by_id( post.from_member)
				member_who_posted.updates.create!( from_member: self.member_id, update_on_type: 'post', update_on_id: post.id, updated_by_type: 'comment', updated_by_id: self.id)
=begin
			Update.where(member_id: member_who_posted.id, update_on_type: 'post', update_on_id: post.id, from_member: self.member_id).each do |u|
				u.created_at = self.created_at
				u.save
			end
			Update.where(member_id: member_who_has_post, updated_by_type: 'post', updated_by_id: post.id, from_member: self.member_id).each do |u|
				u.created_at = self.created_at
				u.save
			end
=end
			end
			unless post.member_id == self.member_id
				member_who_has_post = Member.find_by_id(post.member_id)
				member_who_has_post.updates.create!( from_member: self.member_id, update_on_type: 'post', update_on_id: post.id, updated_by_type: 'comment', updated_by_id: self.id)
			end
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
