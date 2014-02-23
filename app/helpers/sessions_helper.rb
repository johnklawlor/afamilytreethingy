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
	
	def correct_member
		member = Member.find( params[ :id])
		
		unless current_member?(member) ||
					(member.immediate_family_of?(current_member) &&
						!member.full_account?) ||
		current_member.descendant_or_spouse_of_descendant?(member) ||
		current_member.admin?
			flash[ :error] = "You do not have permissions to edit or update this member."
			redirect_to member_path(current_member)
		end
	end
	
	def within_family
		member = Member.find( params[ :id])
		
		unless current_member?(member) ||
					current_member.family_of?(member)
			flash[ :error] = "You do not have permissions to view this member's profile or tree."
			redirect_to member_path(current_member)
		end
	end
end