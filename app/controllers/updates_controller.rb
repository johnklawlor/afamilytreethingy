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
end
