class Post < ActiveRecord::Base

	has_many :comments, dependent: :destroy

	mount_uploader :video, VideoUploader
	mount_uploader :tmp_video, TmpVideoUploader

	mount_uploader :image, ImageUploader
	mount_uploader :tmp_image, TmpImageUploader
	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

	after_save :remove_tmp_image, if: :has_image_and_tmp?
	after_save :remove_tmp_video, if: :has_video_and_tmp?
	after_create :create_update
	after_create :save_image_dimensions
	before_destroy :delete_update
	
	def remove_tmp_image
		remove_tmp_image!
		save!
	end
	
	def has_image_and_tmp?
		(tmp_image? && image?)
	end
	
	def remove_tmp_video
		remove_tmp_video!
	end
	
	def has_video_and_tmp?
		(tmp_video? && video?)
	end

	def self.upload_to_s3(id)
		post = find(id)
		if post.tmp_image?
			logger.debug("i have a tmp img")
			#post.image = post.tmp_image
			post.remove_tmp_image!
		elsif post.tmp_video?
			post.video = post.tmp_video
		end
		post.save!
	end
	
	def create_update
		to_member = Member.find_by_id( self.member_id)
		type = "written"
		type = ( self.image? && 'image') || (self.video? && 'video') || 'written'
		to_member.updates.create!( update_on_type: type, updated_by_type: 'post', updated_by_id: self.id, from_member: self.from_member) unless to_member.id == self.from_member
	end
	
	def delete_update
		Update.where( updated_by_type: 'post', updated_by_id: self.id).each do |update|
			update.destroy
		end
	end
	
	private

		def save_image_dimensions
			if self.tmp_image?
				self.image_width = self.tmp_image.geometry[:width]
				self.image_height = self.tmp_image.geometry[:height]
				save!
			end
		end

end