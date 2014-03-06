class AddAttachmentVideoToPosts < ActiveRecord::Migration
	def self.up
		change_table :posts do |t|
			t.attachment :video
		end
	end

	def self.down
		drop_attached_file :posts, :video
	end
end
