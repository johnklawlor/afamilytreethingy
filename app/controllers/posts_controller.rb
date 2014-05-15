class PostsController < ApplicationController
	before_filter :can_delete?, only: :destroy

	def show
		@post = Post.find_by_id( params[ :id])
	end
	
	def partial
		@post = Post.find_by_id( params[ :id])
		render 'show', layout: false
	end

	def create
		@post = Post.new( post_params)
		if @post.member_id == @post.from_member &&
			@post.member_id != current_member.id
			logger.debug("Member posting to another member's page...")
			respond_to do |format|
				format.js { render file: "posts/illegal_post.js.coffee" }
				format.html { redirect_to member_path( current_member) }
			end
			return
		end
		if( params[ :post][ :tmp_image].present? && params[ :post][ :tmp_image].content_type == "video/mp4")
			@post.tmp_image = nil
			@post.tmp_video = params[ :post][:tmp_image]
		end
		logger.debug("post is #{@post}")
		if @post.save
			QC.enqueue("Post.upload_to_s3", @post.id)
			respond_to do |format|
				format.js
				format.html { redirect_to member_path( current_member) }
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
			params.require( :post).permit( :member_id, :from_member, :content, :tmp_image)
		end
		
		def can_delete?
			unless current_member.can_delete?(Post.find_by_id(params[ :id]))
				redirect_to member_path( current_member), status: 303, error: "You are not allowed to delete this post."
			end
		end
end