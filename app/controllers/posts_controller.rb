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
		if( params[ :post][ :image].present? && params[ :post][ :image].content_type == "video/mp4")
			@post.image = nil
			@post.video = params[ :post][:image]
		end
		if @post.save
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
			params.require( :post).permit( :member_id, :from_member, :content, :image)
		end
		
		def can_delete?
			unless current_member.can_delete?(Post.find_by_id(params[ :id]))
				redirect_to member_path( current_member), status: 303, error: "You are not allowed to delete this post."
			end
		end
end