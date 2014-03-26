class Post < ActiveRecord::Base

	has_many :comments, dependent: :destroy
=begin
	has_attached_file :video, styles: {
		medium: { geometry: "640x480", format: "flv"},
		thumb: { geometry: "100x100#", format: 'jpg', time: 1 }
	}, processors: [ :ffmpeg]
	validates_attachment_content_type :video, content_type: ["video/avi", "video/quicktime", "video/x-msvideo", "video/mp4"]
=end

	mount_uploader :video, VideoUploader
	mount_uploader :tmp_video, TmpVideoUploader

	mount_uploader :image, ImageUploader
	mount_uploader :tmp_image, TmpImageUploader
	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

	after_create :create_update
	after_create :save_image_dimensions
	before_destroy :delete_update

	def self.upload_to_s3(id)
		post = find(id)
		if post.tmp_image?
			post.image = post.tmp_image
			post.remove_tmp_image!
			post.image_width = post.image.geometry[:width]
			post.image_height = post.image.geometry[:height]
		elsif post.tmp_video?
			post.video = post.tmp_video
			post.remove_tmp_video!
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