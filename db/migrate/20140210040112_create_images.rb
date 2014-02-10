class CreateImages < ActiveRecord::Migration
	def change
		create_table :images do |t|
			t.belongs_to :member
			t.string :image_id

			t.timestamps
		end
	end
end