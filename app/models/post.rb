class Post < ActiveRecord::Base

	has_many :comments
	mount_uploader :image, ImageUploader
	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

	after_create :create_update
	before_destroy :delete_update
	
	def create_update
		to_member = Member.find_by_id( self.member_id)
		to_member.updates.create!( update_on_type: 'wall', update_on_id: self.id, from_member: self.from_member) unless to_member.id == self.from_member
	end
	
	def delete_update
		update_to_delete = Update.where( update_on_type: 'wall', update_on_id: self.id).each do |update|
			update.destroy
		end
	end

end
