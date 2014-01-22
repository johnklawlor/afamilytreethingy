module SessionsHelper
	def sign_in(member)
		cookies.permanent[:remember_token] = member.remember_token
		self.current_member = member
	end
	
	def current_member=(member)
		@current_member = member
	end
end