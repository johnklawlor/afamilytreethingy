class ImagesController < ApplicationController
	def new
	end

	def create
		@images = Images.new( params[ :image])
		if @images.save
			member = Member.find_by_id( params[ :image][ :member_id] )
			redirect_to member
		else
			render :new
		end
	end

	def destroy
	end
end
