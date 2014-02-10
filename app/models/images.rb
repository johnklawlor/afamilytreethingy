class Images < ActiveRecord::Base
	mount_uploader :image_id, ImageUploader
	
	belongs_to :member
end
