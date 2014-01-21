class MembersController < ApplicationController
	
	def show
		@member = Member.find(params[ :id])
	end

	def new

	end
end
