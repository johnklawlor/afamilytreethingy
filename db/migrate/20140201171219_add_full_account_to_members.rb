class AddFullAccountToMembers < ActiveRecord::Migration
	def change
		add_column :members, :full_account, :boolean
	end
end
