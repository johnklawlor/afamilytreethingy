class Member < ActiveRecord::Base
	has_secure_password
	
	validates :first_name, presence: true, length: { maximum: 25 }
	validates :last_name, presence: true, length: { maximum: 25 }
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	
	validates :password, length: { minimum: 6 }, if: :should_validate_password?
	validates :password_confirmation, presence: true, if: :should_validate_password?

	private
		def should_validate_password?
			true
			#!self.password_reset_token.nil? || new_record?
		end
end