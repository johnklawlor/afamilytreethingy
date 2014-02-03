class SessionsController < ApplicationController

	def new
	end
	
	def create
		member = Member.find_by_email(params[:session][:email].downcase)
		if member && member.authenticate(params[:session][:password])
			sign_in member
			redirect_back_or tree_path(current_member)
		else
			flash.now[ :error] = "The username and password combination do not match our records. Please try again."
			render 'new'
		end
	end
	
	def destroy
		sign_out
		redirect_to root_path
	end

end