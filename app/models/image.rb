class Image < ActiveRecord::Base
	mount_uploader :image, ImageUploader

	has_many :comments, dependent: :destroy
	has_many :updates, as: :updatable, dependent: :destroy
	
	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

	belongs_to :member
end
