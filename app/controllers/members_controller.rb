class MembersController < ApplicationController

	before_filter :admin_member, only: :destroy
	before_filter :signed_in_filter, only: [ :index, :show, :edit, :update, :destroy, :crop ]
	before_filter :correct_member, only: :edit
	before_filter :correct_member_update, only: :update
	before_filter :within_family, only: :show
		
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
		
		if params[ :commit] == ( 'add child' || 'add parent' || 'add spouse')
			if @member.update_attributes(add_member_params)
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
				elsif params[ :member][ :last_checked_updates].present?
					@member.update_attribute( :last_checked_updates, Time.at(params[ :member][ :last_checked_updates].to_i/1000))
					render nothing: true
				else
					flash[ :success] = "Your profile was updated successfully."
					redirect_to member_path(@member), status: 303
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
	
	def new_post
		@member = Member.find_by_id( params[ :id])
	end
	
	private
	
		def member_params
			params.require(:member).permit(:first_name, :last_name, :birthdate, :email, :password, :password_confirmation, :full_account, :spouse_id, :image, :image_cache, :remove_image, :relationship_type, :relationship_id, :crop_x, :crop_y, :crop_w, :crop_h, :allows_editing, :last_checked_updates, children_attributes: [ :first_name, :last_name, :birthdate, :email, :password, :password_confirmation, :full_account, :spouse_id, :image, :image_cache, :remove_image], parents_attributes: [ :first_name, :last_name, :birthdate, :email, :password, :password_confirmation, :full_account, :spouse_id, :image, :image_cache, :remove_image], spouses_attributes: [ :first_name, :last_name, :birthdate, :email, :password, :password_confirmation, :full_account, :spouse_id, :image, :image_cache, :remove_image])
		end
		
		def add_member_params
			params.require(:member).permit( children_attributes: [ :first_name, :last_name, :birthdate, :email, :password, :password_confirmation, :full_account, :spouse_id, :image, :image_cache, :remove_image], parents_attributes: [ :first_name, :last_name, :birthdate, :email, :password, :password_confirmation, :full_account, :spouse_id, :image, :image_cache, :remove_image], spouses_attributes: [ :first_name, :last_name, :birthdate, :email, :password, :password_confirmation, :full_account, :spouse_id, :image, :image_cache, :remove_image])
		end
		
		def correct_member
			member = Member.find( params[ :id])
		
			unless current_member?(member) ||
						(member.parent_or_child_of?(current_member) &&
							!member.full_account?) ||
						current_member.admin?
				redirect_to member_path(current_member), flash: { error: "You do not have permissions to edit or update this member."}
			end
		end
		
		def correct_member_update
			member = Member.find_by_id( params[ :id])
			logger.debug("Commit is #{['add child', 'add parent', 'add spouse'].include?(params[ :commit])}")

			if current_member?(member)
				return
			end

			if ['add child', 'add parent', 'add spouse'].include?(params[ :commit])
				unless member.allows_editing
					redirect_to member_path( current_member), flash: { error: "This member does not allow other members to edit their tree."}
				end
				
				unless current_member.family_of?(member)
					redirect_to member_path( current_member), flash: { error: "You do not have permissions to edit or update this member."}
				end
			elsif params[ :commit] == 'update my profile'
				unless ( !member.full_account && current_member.parent_or_child_of?(member) )
					redirect_to member_path( current_member), flash: { error: "You do not have permissions to edit or update this member."}
				end
			else redirect_to root_path, flash: { error: "We don't know what you're trying to do, so we've sent you here." }
			end
		end
end
