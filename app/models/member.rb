class Member < ActiveRecord::Base
	attr_accessor :rel, :rel_id

	has_many :parents, through: :reverse_relationships, source: :parent
	has_many :children, through: :relationships, source: :child
	has_many :relationships, foreign_key: "parent_id", dependent: :destroy
	has_many :reverse_relationships, foreign_key: "child_id", class_name: Relationship, dependent: :destroy

	has_secure_password(validations: false)
	mount_uploader :image, ImageUploader
	
	before_save :nil_or_downcase
	before_create { create_token(:remember_token) }
	
	validates :first_name, presence: true, length: { maximum: 25 }
	validates :last_name, presence: true, length: { maximum: 25 }
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :email, presence: true, if: :account?, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	
	def nil_or_downcase
		if self.email.blank?
			self.email = nil
		else
			self.email.downcase!
		end
	end
	
	def account?
		self.full_account
	end

	def Member.new_token
		SecureRandom.urlsafe_base64
	end

	def Member.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end
	
	def spouse
		Member.find(self.spouse_id)
	end
	
	def has_spouse?
		!Member.find_by_id(self.spouse_id).nil?
	end
	
	def has_children?
		!self.children.empty?
	end
	
	def name
		self.first_name + " " + self.last_name
	end
	
	private		
		def create_token(column)
			self[column] = Member.encrypt(Member.new_token)
		end
end