class AddOldestAncestorToMembers < ActiveRecord::Migration
	def change
		add_column :members, :oldest_ancestor, :integer
	end
end
