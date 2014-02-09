class RemovePasswordDigestFromMembers < ActiveRecord::Migration
	def up
		remove_column :members, :password_digest
	end
	
	def down
		add_column :members, :password_digest, :string
	end
end
