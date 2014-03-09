class Post < ActiveRecord::Base

	has_many :comments
	has_attached_file :video, styles: {
		medium: { geometry: "640x480", format: "flv"},
		thumb: { geometry: "100x100#", format: 'jpg', time: 1 }
	}, processors: [ :ffmpeg]
	validates_attachment_content_type :video, content_type: ["video/avi", "video/quicktime", "video/x-msvideo", "video/mp4"]

	
	mount_uploader :image, ImageUploader
	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

	after_create :create_update
	before_destroy :delete_update
	
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

end
