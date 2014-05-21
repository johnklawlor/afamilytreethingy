class AuthApiController < ApplicationController
	protect_from_forgery except: :create

	def create
		member = Member.find_by_email(params[:email].downcase)
		if member && member.authenticate(params[:password])
			logger.debug("signing in via api...")
			sign_in(member, :api_token)
		
			render status: 200, json: {
				api_token: member.api_token
			}
		else
		
		end
	end
	
	def destroy
	end
end
