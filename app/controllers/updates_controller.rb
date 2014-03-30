class UpdatesController < ApplicationController
	def posts
		if signed_in?
			@new_posts = []
			most_recent_post = params[ :most_recent_post].to_i + 2
			member = Member.find_by_id( params[ :member_id])
			member.updates.where( "updated_by_type= 'post' and created_at > ?", Time.at( most_recent_post)).each do |update|
				@new_posts << Post.find_by_id( update.updated_by_id)
			end
			@updates_count = current_member.updates.where("created_at > ?", current_member.last_checked_updates).count
		
			respond_to do |format|
				format.js
			end
		end
	end
	
	def comments
		post = Post.find_by_id( params[ :post_id])
		most_recent_comment = params[ :most_recent_comment].to_i + 1
		if signed_in?
			updates = current_member.updates.where( "update_on_type= 'post' and updated_by_type='comment' and update_on_id= ? and created_at > ?", post.id, Time.at( most_recent_comment))
			@new_comments = Comment.where( id: updates.select( :updated_by_id)).order('created_at DESC')

			respond_to do |format|
				format.js
			end
		end
	end
	
	def updates
		@updates = current_member.updates.order('created_at DESC')

		respond_to do |format|
			format.js
			format.html
		end
	end

end
