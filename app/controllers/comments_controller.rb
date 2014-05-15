class CommentsController < ApplicationController
	
	before_filter :signed_in_filter
	before_filter :can_delete?, only: :destroy
	
	def create
		@comment = Comment.create( comment_params)
		@post_id = @comment.post_id.to_s
		@to_member = current_member.id.to_s
		@show_spacebar_hint = current_member.show_spacebar_hint
	end

	def destroy
		@comment_to_delete = Comment.find_by_id( params[ :id])
		@comment_to_delete.destroy
		respond_to do |format|
			format.js
			format.html { redirect_to image_path( @comment_to_delete.image_id) }
		end
	end
	
	private
	
		def comment_params
			params.require(:comment).permit(:post_id, :member_id, :member_name, :content)
		end
		
		def can_delete?
			comment = Comment.find_by_id( params[ :id])
			unless current_member.can_delete_comment?(comment) || current_member.admin?
				redirect_to :back, status: 303, error: "You do not have permissions to delete this comment."
			end
		end
end
