include MembersHelper

class MembersController < ApplicationController
	before_filter :admin_member, only: :destroy
	before_filter :signed_in_filter, only: [ :index, :create, :edit, :update, :destroy ]
	
	def index
		@members = Member.all.order('birthdate').paginate(page: params[ :page])
	end
	
	def show
		@member = Member.find(params[ :id])
	end

	def new
		@member = Member.new
		@member.rel = params[ :rel]
		@member.rel_id = params[ :rel_id]
	end
	
	def create
		@member = Member.new(member_params)
		rel = @member.rel
		rel_id = @member.rel_id
		
		if @member.save
		
			unless @member.spouse_id.nil?
				spouse = Member.find_by_id(@member.spouse_id)
				spouse.spouse_id = @member.id
				spouse.save
			end
		
			if rel == 'parent'
				@member.relationships.create!(child_id: rel_id)
				update_ancestor( rel_id, @member.id)
				redirect_to tree_path(@member)
			elsif rel == 'child'
				@member.reverse_relationships.create!(parent_id: rel_id)
				parent = Member.find_by_id(rel_id)
				unless (other_parent = parent.spouse_id).nil?
					@member.reverse_relationships.create!(parent_id: other_parent)
				end
				@member.oldest_ancestor = parent.oldest_ancestor
				@member.save
				redirect_to tree_path(@member)
			elsif rel == 'spouse'
				@member.spouse_id = rel_id
				@member.oldest_ancestor = @member.id
				@member.save
				spouse = Member.find_by_id(rel_id)
				spouse.spouse_id = @member.id
				spouse.save
				spouse.relationships.each do |r|
					@member.relationships.create(child_id: r.child_id)
				end
				redirect_to tree_path(@member)
			else
				sign_in @member
				flash[ :success] = "welcome!"
				redirect_to root_path
			end
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
	
	def destroy
		member_to_delete = Member.find( params[ :id] )
		if current_member?(member_to_delete)
			flash[ :error] = "You cannot delete yourself!"
			redirect_to member_path(user_to_delete)
		else
			member_to_delete.destroy
			flash[ :success] = "Member destroyed."
			redirect_to members_path
		end
	end
	
	private
	
		def member_params
			params.require(:member).permit(:first_name, :last_name, :email, :birthdate, :full_account, :spouse_id, :password, :password_confirmation, :image, :image_cache, :remove_image, :rel, :rel_id)
		end
		
		def admin_member
			redirect_to(root_path) unless current_member.admin?
		end
end
