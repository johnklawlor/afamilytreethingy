class CreateUpdates < ActiveRecord::Migration
	def change
		create_table :updates do |t|
			t.references :updatable, polymorphic: true
			t.string :what
			t.integer :what_id
			t.boolean :viewed, default: false

			t.timestamps
		end
	end
end
