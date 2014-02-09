class MemberMailer < ActionMailer::Base
	default from: "john@mypeeps.com"
	
	def reset_password(member)
		@member = member
		mail( to: member.email, subject: "Welcome to mypeeps!" )
	end
	
end