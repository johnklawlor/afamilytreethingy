class CreateComments < ActiveRecord::Migration
	def change
		create_table :comments do |t|
			t.belongs_to :image
			t.integer :member_id
			t.string :member_name
			t.string :content

			t.timestamps
		end
	end
end
