class CreatePosts < ActiveRecord::Migration
	def change
		create_table :posts do |t|
			t.belongs_to :member
			t.belongs_to :update
			t.text :content
			t.integer :from_member
			t.string :image

			t.timestamps
		end
	end
end
