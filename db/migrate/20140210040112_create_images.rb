class CreateImages < ActiveRecord::Migration
	def change
		create_table :images do |t|
			t.belongs_to :member
			t.string :image

			t.timestamps
		end
	end
end