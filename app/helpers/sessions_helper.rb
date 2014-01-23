module SessionsHelper
	def sign_in(member)
		remember_token = Member.new_token
		cookies.permanent[:remember_token] = remember_token
		member.update_attribute(:remember_token, Member.encrypt(remember_token))
		self.current_member = member
	end
	
	def signed_in?
		!current_member.nil?
	end
	
	def current_member=(member)
		@current_member = member
	end
	
	def current_member
		remember_token = Member.encrypt(cookies[:remember_token])
		@current_member ||= Member.find_by(remember_token: remember_token)
	end
	
	def sign_out
		self.current_member = nil
		cookies.delete(:remember_token)
	end
	
	def signed_in_filter
		unless signed_in?
			store_location
			redirect_to signin_path, notice: "Please sign in."
		end
	end
	
	def store_location
		session[:return_to] = request.fullpath
	end
	
	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end
end