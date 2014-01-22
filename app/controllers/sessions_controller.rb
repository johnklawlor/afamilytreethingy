class SessionsController < ApplicationController

	def new
	end
	
	def create
		member = Member.find_by_email(params[:session][:email])
		if member && member.authenticate(params[:session][:password])
			sign_in member
			redirect_back_or member
		else
			flash[ :error] = "The username and password combination do not match our records. Please try again."
			render 'new'
		end
	end
	
	def destroy
	end

end