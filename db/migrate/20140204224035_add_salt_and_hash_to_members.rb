class AddSaltAndHashToMembers < ActiveRecord::Migration
	def change
		add_column :members, :password_hash, :string
		add_column :members, :password_salt, :string
	end
end
