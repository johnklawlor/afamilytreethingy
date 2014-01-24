class MembersController < ApplicationController
	
	def index
		@members = Member.all.paginate(page: params[ :page])
	end
	
	def show
		@member = Member.find(params[ :id])
	end

	def new
		@member = Member.new
	end
	
	def create
		@member = Member.new(member_params)
		if @member.save
			sign_in @member
			flash[ :success] = "Welcome!"
			redirect_to root_path
		else
			render 'new'
		end
	end
	
	private
	
		def member_params
			params.require(:member).permit(:first_name, :last_name, :email, :password, :password_confirmation, :image)
		end
end
