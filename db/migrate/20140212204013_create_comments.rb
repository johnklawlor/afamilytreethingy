class CreateComments < ActiveRecord::Migration
	def change
		create_table :comments do |t|
			t.belongs_to :post
			t.integer :member_id
			t.string :content

			t.timestamps
		end
	end
end
