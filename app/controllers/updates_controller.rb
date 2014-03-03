class UpdatesController < ApplicationController
	def posts
		if signed_in?
			@new_posts = []
			current_member.updates.where( update_on_type: 'wall', viewed: false).each do |update|
				@new_posts << Post.find_by_id( update.update_on_id)
				update.viewed = true
				update.save
			end
			@updates_count = current_member.updates.where(counted: false).count
		
			respond_to do |format|
				format.js
			end
		end
	end
	
	def comments
		post = Post.find_by_id( params[ :post_id])
		if signed_in?
			updates = current_member.updates.where( update_on_type: 'post', updated_by_type: 'comment', update_on_id: post.id, viewed: false)
			@new_comments = Comment.where( id: updates.select( :updated_by_id))

			respond_to do |format|
				format.js
			end
			
			updates.each do |update|
				unless update.viewed
					update.viewed = true
					update.save
				end
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
