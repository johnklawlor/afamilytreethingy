class AddImageGeometryToPosts < ActiveRecord::Migration
	def change
		add_column :posts, :image_width, :string
		add_column :posts, :image_height, :string
	end
end
