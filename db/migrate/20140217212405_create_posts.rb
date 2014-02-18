class CreatePosts < ActiveRecord::Migration
	def change
		create_table :posts do |t|
			t.belongs_to :member
			t.text :content
			t.integer :from_member

			t.timestamps
		end
	end
end
