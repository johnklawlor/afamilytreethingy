class Update < ActiveRecord::Base

	belongs_to :member
	belongs_to :updated_by, polymorphic: true

end
