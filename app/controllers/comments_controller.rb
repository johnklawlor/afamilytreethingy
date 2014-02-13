class CommentsController < ApplicationController
	before_filter :signed_in_filter

	def create
		@comment = Comment.new( image_params)
		@comment.save
		respond_to do |format|
			format.js
			format.html
		end
	end

	def destroy
	end
	
	private
		def image_params
			params.require(:comment).permit(:image_id, :member_id, :member_name, :content)
		end
end
