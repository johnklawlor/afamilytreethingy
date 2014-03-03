class CreateUpdateRelationships < ActiveRecord::Migration
	def change
		create_table :update_relationships do |t|
			t.integer :update_id
			t.integer :comment_id

			t.timestamps
		end
	end
end
