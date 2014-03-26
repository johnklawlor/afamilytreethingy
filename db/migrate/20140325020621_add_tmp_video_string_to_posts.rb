class AddTmpVideoStringToPosts < ActiveRecord::Migration
	def change
		add_column :posts, :tmp_video, :string
	end
end
