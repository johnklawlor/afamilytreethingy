class MembersController < ApplicationController
	
	def show
		@member = Member.find(params[ :id])
	end

	def new
		@member = Member.new
	end
	
	def create
		@member = Member.new(params.require(:member).permit(:first_name, :last_name, :email, :password, :password_confirmation))
		if @member.save
			flash[ :success] = "Welcome!"
			redirect_to root_path
		else
			render 'new'
		end
	end
end
