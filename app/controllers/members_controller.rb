class MembersController < ApplicationController
	before_filter :admin_member, only: :destroy
	before_filter :signed_in_filter, only: [ :index, :edit, :update, :destroy ]
	before_filter :correct_member, only: [ :edit, :update]
	
	def index
		@members = Member.all.order('last_name', 'first_name').paginate(page: params[ :page])
	end
	
	def show
		@member = Member.find_by_id(params[ :id])
	end

	def new
		@member = Member.new
		@member.children.new
	end
	
	def create
		@member = Member.new(member_params)

		if @member.save
			if @member.full_account?
				@member.activate_member
				sign_in @member
				redirect_to tree_path(@member)
			else
				redirect_to member_path(@member)
			end
		else
			render 'new'
		end
	end
	
	def edit
		@member = Member.find_by_id(params[:id])
	end
	
	def update
		@member = Member.find_by_id(params[:id])
		
		if params[ :commit] == 'add child' || 
		params[ :commit] == 'add parent' ||
		params[ :commit] == 'add spouse'
			if @member.update_attributes(member_params)
				flash[ :success] = "Member added to your tree!"
				redirect_to edit_tree_path( @member)
			else
				render 'tree/edit'
			end
		else
			if @member.update_attributes(member_params)
				flash[ :success] = "Your profile was updated successfully."
				redirect_to @member
			else
				render 'edit'
			end
		end
	end
	
	def destroy
		member_to_delete = Member.find( params[ :id] )
		if current_member?(member_to_delete)
			flash[ :error] = "You cannot delete yourself!"
			redirect_to member_path(member_to_delete)
		else		
			member_to_delete.destroy
			flash[ :success] = "Member destroyed."
			redirect_to members_path
		end
	end
	
	private
	
		def member_params
			params.require(:member).permit(:first_name, :last_name, :birthdate, :email, :password, :password_confirmation, :full_account, :spouse_id, :image, :image_cache, :remove_image, :relationship_type, :relationship_id, children_attributes: [ :first_name, :last_name, :birthdate, :email, :password, :password_confirmation, :full_account, :spouse_id, :image, :image_cache, :remove_image], parents_attributes: [ :first_name, :last_name, :birthdate, :email, :password, :password_confirmation, :full_account, :spouse_id, :image, :image_cache, :remove_image], spouses_attributes: [ :first_name, :last_name, :birthdate, :email, :password, :password_confirmation, :full_account, :spouse_id, :image, :image_cache, :remove_image])
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
			
			unless member.immediate_family_of?(current_member) || current_member?(member) || admin_member
				flash[ :error] = "You do not have permissions to edit or update this member."
				redirect_to(root_path)
			end
		end
end
