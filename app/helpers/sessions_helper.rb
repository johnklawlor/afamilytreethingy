module SessionsHelper
	def sign_in(member, token_type)
		token = Member.new_token
		if token_type == :remember_token
			cookies.permanent[:remember_token] = token
			member.update_attribute(:remember_token, Member.encrypt(token))
		elsif token_type == :api_token
			member.update_attribute(:api_token, token)
		end
		self.current_member = member
	end
	
	def signed_in?
		!current_member.nil?
	end
	
	def current_member=(member)
		@current_member = member
	end
	
	def current_member
		if cookies[:remember_token].present?
			remember_token = Member.encrypt(cookies[:remember_token])
			@current_member ||= Member.find_by(remember_token: remember_token)
		elsif request.headers["passport"].present?
			api_token = request.headers["passport"]
			@current_member ||= Member.find_by_api_token(api_token)
		else
			nil
		end
	end
	
	def current_member?(member)
		member == current_member
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
	
	def admin_member
		if current_member.admin?
			return true
		else
			redirect_to(root_path)
		end
	end
	
	def within_family
		member = Member.find( params[ :id])
		
		unless current_member?(member) ||
					current_member.family_of?(member)
			redirect_to member_path(current_member), flash: { error: "You do not have permissions to view this member's profile or tree."}
		end
	end
end