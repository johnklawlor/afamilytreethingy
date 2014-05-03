class PasswordResetsController < ApplicationController

	def new
	end
	
	def create
		member = Member.find_by_email( params[:email])
		member.send_password_reset_email if member
		redirect_to root_path, notice: "We've sent you an email with password reset instructions. If you do not receive an email, check your spam, or trying entering a different email address you may have signed up with."
	end
	
	def edit
		@member = Member.find_by_password_reset_token( params[ :id])
		if @member.nil?
			flash[:error] = "This link is dead! If you need you need to reset your password, click on the link below. Otherwise, what are you waiting for? Sign in!"
			redirect_to signin_path
		end
	end
	
	def update
		@member = Member.find_by_password_reset_token!( params[ :id])
		if @member.password_reset_sent_at < 2.hours.ago
			redirect_to new_password_reset_path, notice: "Password reset has expired. Visit the forgot password link below."
		elsif @member.update_attributes(member_params)
			@member.reset_token
			@member.activate_member
			sign_in @member
			redirect_to member_path(@member)
		else
			render :edit
		end
	end
	
	private
		def member_params
			params.require( :member).permit(  :password, :password_confirmation )
		end

end
