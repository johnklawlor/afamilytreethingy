class PostsController < ApplicationController

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