class AddApiTokenToMembers < ActiveRecord::Migration
	def change
		add_column :members, :api_token, :string
		add_index :members, :api_token, unique: true
	end
end
