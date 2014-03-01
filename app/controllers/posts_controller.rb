class PostsController < ApplicationController
#	include ActionController::Live

=begin
	def events
		response.headers["Content-Type"] = "text/event-stream"
		start = Post.last.created_at
		10.times do
			Post.uncached do
				Post.where('created_at > ?', start).each do |post|
					response.stream.write "data: #{render_to_string partial: 'posts/post.html.erb', object: post}\n\n"
					start = post.created_at
				end
			end
			sleep 2		
		end
		rescue IOError
			logger.info "Stream closed"
		ensure
			response.stream.close
	end
=end

	def show
		@post = Post.find_by_id( params[ :id])
	end

	def create
		@post = ( params[ :member_id].present? && Post.new( member_id: params[ :member_id], from_member: params[ :from_member], content: params[ :content], image: params[ :post][ :image]) || Post.new( post_params))
		if @post.save
			respond_to do |format|
				format.js
				format.html { redirect_to member_path( @post.member_id) }
			end
		else
			flash[ :error] = "We're sorry. We were unable to post your post!"
		end
	end

	def edit
	end

	def update
	end

	def destroy
		@post_to_delete = Post.find_by_id( params[ :id])
		@post_to_delete.destroy
		respond_to do |format|
			format.js
			format.html { redirect_to member_path( @post_to_delete.member_id) }
		end
	end
	
	private
		def post_params
			params.require( :post).permit( :member_id, :from_member, :content, :image)
		end
end