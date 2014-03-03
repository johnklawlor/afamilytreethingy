class CreateUpdates < ActiveRecord::Migration
	def change
		create_table :updates do |t|
			t.belongs_to :member
			t.references :updated_by, polymorphic: true
			t.boolean :viewed, default: false
			t.boolean :counted, default: false
			t.integer :from_member
			t.string :update_on_type
			t.integer :update_on_id

			t.timestamps
		end
	end
end
