class Update < ActiveRecord::Base

	belongs_to :member
	belongs_to :updatable, polymorphic: true

end
