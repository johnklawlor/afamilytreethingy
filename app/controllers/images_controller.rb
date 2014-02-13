class ImagesController < ApplicationController
	before_filter :signed_in_filter

	def new
	end

	def create
		image = params[ :image][ :image]
		member = params[ :member_id]
		@images = Image.create( member_id: member, image: image)
		@member = Member.find_by_id( member)
	end
	
	def show
		@image = Image.find_by_id( params[ :id])
	end

	def destroy
		@image = Image.find_by_id( params[ :id])
		@image.destroy
		redirect_to member_path(current_member)
	end
	
	private
		
		def image_params
			params.require( :image).permit( :image)
		end
end
