class UpdatesController < ApplicationController
	def posts
		if signed_in?
			@new_posts = []
			current_member.updates.where( what: 'post', viewed: false).each do |update|
				@new_posts << Post.find_by_id( update.what_id)
				update.toggle!(:viewed)
			end
		
			respond_to do |format|
				format.js
			end
		end
	end
	
	def comments
		image = Image.find_by_id( params[ :image_id])
		if signed_in?
			@new_comments = []
			current_member.updates.where( what: 'comment', viewed: false).each do |update|
				@new_comments << Comment.find_by_id( update.what_id)
				unless update.viewed
					update.viewed = true
					update.save
				end
			end
		
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
