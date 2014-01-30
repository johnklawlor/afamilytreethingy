class MembersController < ApplicationController
	
	def index
		@members = Member.all.paginate(page: params[ :page])
	end
	
	def show
		@member = Member.find(params[ :id])
	end

	def new
		@member = Member.new
	end
	
	def create
		@member = Member.new(member_params)
		if @member.save
			sign_in @member
			flash[ :success] = "Welcome!"
			redirect_to root_path
		else
			render 'new'
		end
	end
	
	def edit
		@member = Member.find(params[:id])
	end
	
	def update
		@member = Member.find(params[:id])
		if @member.update_attributes(member_params)
			flash[:success] = "Your profile has been updated!"
			redirect_to @member
		else
			render 'edit'
		end
	end
	
	def tree
		@family= 
		{
			id: "1",
			name: "Mom",
			children: [{
				id: "2",
				name: "Daniel",
				children: [{
					id: "3",
					name: "Kieran",
					children: []}
				]}
			]}.to_json.html_safe

		respond_to do |format|
			format.js
			format.html
		end
	end
	
	private
	
		def member_params
			params.require(:member).permit(:first_name, :last_name, :email, :password, :password_confirmation, :image, :image_cache, :remove_image)
		end
end
