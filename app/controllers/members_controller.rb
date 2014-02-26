class MembersController < ApplicationController

	before_filter :admin_member, only: :destroy
	before_filter :signed_in_filter, only: [ :index, :edit, :update, :destroy, :crop ]
	before_filter :correct_member, only: [ :edit, :update]
	before_filter :within_family, only: :show
		
	def index
		@members = Member.all.order('last_name', 'first_name').paginate(page: params[ :page])
	end
	
	def show
		@member = Member.find_by_id(params[ :id])
		@member.updates.where(what: 'post', viewed: false).each do |update|
			update.viewed = true
			update.save
		end
	end

	def new
		@member = Member.new
		@member.children.new
	end
	
	def create
		@member = Member.new(member_params)

		if @member.save
			if @member.full_account?
				sign_in @member
				if params[ :member][ :image].present?
					render :crop
				else
					redirect_to tree_path(@member)
				end
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
				if params[ :member][ :image].present?
					respond_to do |format|
						format.js { render 'members/crop' }
						format.html { render 'crop' }
					end
				else
					flash[ :success] = "Your profile was updated successfully."
					redirect_to member_path(@member)
				end
			else
				render :edit
			end
		end
	end
	
	def crop
		@member = Member.find_by_id( params[ :id])
		if @member.image?
			render :crop
		else
			redirect_to member_path(@member)
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
			params.require(:member).permit(:first_name, :last_name, :birthdate, :email, :password, :password_confirmation, :full_account, :spouse_id, :image, :image_cache, :remove_image, :relationship_type, :relationship_id, :crop_x, :crop_y, :crop_w, :crop_h, children_attributes: [ :first_name, :last_name, :birthdate, :email, :password, :password_confirmation, :full_account, :spouse_id, :image, :image_cache, :remove_image], parents_attributes: [ :first_name, :last_name, :birthdate, :email, :password, :password_confirmation, :full_account, :spouse_id, :image, :image_cache, :remove_image], spouses_attributes: [ :first_name, :last_name, :birthdate, :email, :password, :password_confirmation, :full_account, :spouse_id, :image, :image_cache, :remove_image])
		end
		
end
