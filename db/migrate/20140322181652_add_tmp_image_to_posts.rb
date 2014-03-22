class AddTmpImageToPosts < ActiveRecord::Migration
	def change
		add_column :posts, :tmp_image, :string
	end
end
