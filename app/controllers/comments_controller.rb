class CommentsController < ApplicationController
	include ActionController::Live
	
	before_filter :signed_in_filter
	before_filter :can_delete?, only: :destroy

	def create
		@comment = Comment.create( comment_params)
	end

	def destroy
		@comment_to_delete = Comment.find_by_id( params[ :id])
		@comment_to_delete.destroy
		respond_to do |format|
			format.js
			format.html { redirect_to image_path( @comment_to_delete.image_id) }
		end
	end
	
	def events
		response.headers["Content-Type"] = "text/event-stream"
		redis = Redis.new(:url => ENV['REDISTOGO_URL'])
		redis.subscribe(['comments.create','heartbeat']) do |on|
			on.message do |event, data|
				logger.info("redis message received on channel #{event}")
				if event == 'comments.create'
					response.stream.write("event: comments.create\ndata: #{data} \n\n")
				elsif event == 'heartbeat'
					response.stream.write("event: heartbeat\ndata: heartbeat \n\n")
				end
			end
		end
		rescue IOError
			logger.info "Stream closed"
		ensure
			redis.quit
			response.stream.close
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
