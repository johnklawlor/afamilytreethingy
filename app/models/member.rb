include MembersHelper

class Member < ActiveRecord::Base
	include ActiveModel::Validations
	has_many :parents, through: :reverse_relationships, source: :parent
	has_many :children, through: :relationships, source: :child
	has_many :relationships, foreign_key: "parent_id", dependent: :destroy
	has_many :reverse_relationships, foreign_key: "child_id", class_name: Relationship, dependent: :destroy
	has_many :spouses, through: :spouse_relationships, source: :spouse
	has_many :spouse_relationships, foreign_key: "member_id", dependent: :destroy
	has_many :images, dependent: :destroy
	has_many :posts, dependent: :destroy
	has_many :updates, dependent: :destroy
	
	accepts_nested_attributes_for :parents, reject_if: proc { |attributes| attributes['first_name'].blank? && attributes['first_name'].blank? }
	accepts_nested_attributes_for :spouses, reject_if: proc { |attributes| attributes['first_name'].blank? && attributes['first_name'].blank? }
	accepts_nested_attributes_for :children, reject_if: proc { |attributes| attributes['first_name'].blank? && attributes['first_name'].blank? }
	
	attr_accessor :password, :crop_x, :crop_y, :crop_w, :crop_h
	
	before_create :encrypt_password, :nil_or_downcase
	before_create { create_token(:remember_token) }
	before_save :nil_or_downcase
	after_create :set_oldest_ancestor, :activate_member
	after_update :crop_profile_image

	before_destroy :set_ancestor_for_children, :destroy_spouse_id_of_spouse, :delete_posts_from_member, :delete_comments_from_member
	
	state_machine initial: :inactive do
		state :inactive, value: 0
		state :active, value: 1
	
		event :activate_member do
			transition :inactive => :active
		end
	
		event :inactivate_member do
			transition :active => :inactive
		end
	end

	mount_uploader :image, ImageUploader
	
	validates :first_name, presence: true, length: { maximum: 25 }
	validates :last_name, presence: true, length: { maximum: 25 }
	
	VALID_BIRTHDATE_REGEX = /(18|19|20)\d\d[-.](0[1-9]|1[012])[-.](0[1-9]|[12][0-9]|3[01])/
	
	validate :birthdate_format
	
	def birthdate_format	
		unless VALID_BIRTHDATE_REGEX.match( birthdate.to_s )
			errors.add( :birthdate, "must be in the format yyyy-mm-dd")
		end
	end
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	

	validates :password, length: { minimum: 6 }, if: [ :account?, :inactive?]
	validates :password_confirmation, presence: true, if: [ :account?, :inactive?]
	validates_confirmation_of :password, if: [ :account?, :inactive? ]
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }, if: :account?
	
	def delete_comments_from_member
		Comment.where( member_id: self.id).each do |comment|
			comment.destroy
		end
	end
	
	def delete_posts_from_member
		Post.where( from_member: self.id).each do |post|
			post.destroy
		end
	end
	
	def can_delete_comment?(comment)
		image = Image.find_by_id(comment.image_id)
		(comment.member_id == self.id || image.member_id == self.id)
	end
	
	def can_delete?(post)
		(post.member_id == self.id || post.from_member == self.id)
	end
	
	def crop_profile_image
		image.recreate_versions! if crop_x.present?
	end
	
	def set_oldest_ancestor
		self.oldest_ancestor = self.id if self.oldest_ancestor.nil?
		save
	end
	
	def set_ancestor_for_children
		if self.has_children?
			self.children.each do |child|
				if child.parents.count == 2
					new_ancestor = child.parents.where.not(id: self.id).first.id
				else new_ancestor = child.id end
				remove_ancestor( child.id, new_ancestor )
			end
		end
	end
	
	def destroy_spouse_id_of_spouse
		if self.has_spouse?
			spouse = self.spouse
			spouse.spouse_id = nil
			spouse.save					
		end
	end
	
	def self.not(member)
		Member.where.not(id: [member] + member.children + member.parents + member.spouses).order('last_name', 'first_name')
	end
	
	def nil_or_downcase
		self.email.blank? ?	self.email = nil : self.email.downcase!
	end
	
	def send_password_reset_email
		create_token( :password_reset_token)
		self.password_reset_sent_at = Time.zone.now
		self.state="inactive"
		save(validate: false)
		MemberMailer.reset_password(self).deliver
	end
	
	def reset_token
		self.password_reset_token = nil
		self.password_reset_sent_at = nil
		save
	end
	
	def account?
		self.full_account
	end
	
	def password_reset?
		!self.password_reset_token.nil?
	end

	def Member.new_token
		SecureRandom.urlsafe_base64
	end

	def Member.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end
	
	def spouse
		Member.find_by_id(self.spouse_id)
	end
	
	def has_spouse?
		Member.find_by_id(self.spouse_id).present?
	end
	
	def has_children?
		!self.children.empty?
	end
	
	def has_parents?
		!self.parents.empty?
	end
	
	def immediate_family_of?(member)
		if self.has_children?
			return true if self.children.include?(member)
		end
		if self.has_parents?
			return true if self.parents.include?(member)
		end
		if self.has_spouse?
			return true if self.spouse == member
		end		
		false
	end
	
	def name
		self.first_name + " " + self.last_name
	end
	
	def descendants
		d=[]
		self.children.each do |child|
			d << child
			if child.has_children?
				d.concat( child.descendants )
			end
		end
		d
	end
	
	def descendants_and_their_spouses
		d=[]
		self.children.each do |child|
			d << child
			if child.spouses.present?
				d.concat( child.spouses)
			end
			if child.has_children?
				d.concat( child.descendants_and_their_spouses )
			end
		end
		d	
	end

	def ancestors(degrees)
		return [] if degrees==0
		a = []
		self.parents.each do |parent|
			a << parent
			if parent.has_parents?
				a.concat( parent.ancestors(degrees-1) )
			end
		end
		a << self
	end
	
	def siblings
		unless self.has_parents?
			return nil
		end
		self.parents.first.children.where.not(id: self.id)
	end
	
	def other_spouses( previous_spouse)
		self.spouses.where.not(id: previous_spouse)
	end
	
	def family_of?(member)
		member.ancestors(6).each do |a|
			if self.ancestors(6).include?(a)
				return true
			end
		end
		false
	end

	def descendant_or_spouse_of_descendant?(member)
		member.descendants.each do |descendant|
			if descendant == self
				return true
			elsif descendant.has_spouse?
				if descendant.spouse == self
					return true
				end
			end
		end
		return false
	end
	
	def authenticate(password)
		member = Member.find_by_email(self.email)
		member && 
		member.password_hash? &&
		member.password_hash == BCrypt::Engine.hash_secret(password, member.password_salt) ?
			member
			: nil
	end

	def encrypt_password
		if password.present?
			self.password_salt = BCrypt::Engine.generate_salt
			self.password_hash = BCrypt::Engine.hash_secret( password, password_salt)
		end
	end

	private		
		def create_token(column)
			self[column] = Member.encrypt(Member.new_token)
		end		
end