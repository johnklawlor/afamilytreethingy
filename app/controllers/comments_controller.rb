class CommentsController < ApplicationController
	before_filter :signed_in_filter
	before_filter :correct_member, only: :destroy

	def create
		@comment = Comment.new( image_params)
		@comment.save
		respond_to do |format|
			format.js
			format.html
		end
	end

	def destroy
		@comment_to_delete = Comment.find_by_id( params[ :id])
		image = @comment_to_delete.image_id
		@comment_to_delete.destroy
		respond_to do |format|
			format.js
			format.html { redirect_to image_path(image) }
		end
	end
	
	private
		def image_params
			params.require(:comment).permit(:image_id, :member_id, :member_name, :content)
		end
		
		def correct_member
			comment = Comment.find_by_id( params[ :id])
			member = Member.find_by_id( comment.member_id)
			
			unless current_member?( member) || current_member.admin?
				flash[ :error] = "You do not have permissions to delete this comment."
				redirect_to image_path( comment.image_id)
			end
		end
end
