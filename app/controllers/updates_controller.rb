class UpdatesController < ApplicationController
	def posts
		if signed_in?
			@new_posts = []
			current_member.updates.where( what: 'post').each do |update|
				@new_posts << Post.find_by_id( update.what_id)
				update.destroy
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
			image.updates.where( what: 'comment').each do |update|
				@new_comments << Comment.find_by_id( update.what_id)
				update.destroy
			end
		
			respond_to do |format|
				format.js
			end
		end
	end
end
