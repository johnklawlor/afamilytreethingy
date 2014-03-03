class Update < ActiveRecord::Base

	has_many :comments, through: :update_relationships

end
