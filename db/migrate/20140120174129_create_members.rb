class CreateMembers < ActiveRecord::Migration
	def up
		create_table :members do |t|
			t.string :first_name
			t.string :last_name
			t.string :email
			t.string :password_digest
			t.string :remember_token
			t.boolean :admin, default: false
			t.boolean :allows_editing, default: true
			t.datetime :last_checked_updates
			
			t.timestamps
		end
		add_index :members, :email, unique: true
		add_index :members, :remember_token
	end
	
	def down
		drop_table :members
	end
end
