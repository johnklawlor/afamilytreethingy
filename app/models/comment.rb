class Comment < ActiveRecord::Base
	include ActionView::Helpers::DateHelper

	has_one :update, as: :updated_by

	after_create :create_update
#	after_create :publish_comment
	before_destroy :delete_update
	
	def publish_comment
		from_whom = Member.find_by_id(self.member_id)
		comment = { comment: self, name: from_whom.first_name.downcase, sent_when: time_ago_in_words(self.created_at).to_s + ' ago', url: from_whom.image_url( :micro) }.to_json
		$redis.publish( 'comments.create', comment)
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
		if post.member_id != self.member_id
			member = Member.find_by_id( post.member_id)
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
end
