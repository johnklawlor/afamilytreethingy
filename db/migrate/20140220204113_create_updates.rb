class CreateUpdates < ActiveRecord::Migration
	def change
		create_table :updates do |t|
			t.belongs_to :member
			t.string :what
			t.integer :what_id
			t.boolean :viewed, default: false
			t.integer :from_member
			t.string :commented_on_type
			t.integer :commented_on_id

			t.timestamps
		end
	end
end
