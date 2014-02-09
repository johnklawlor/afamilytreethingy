class AddStateMachineToMembers < ActiveRecord::Migration
	def change
		add_column :members, :state, :integer
		add_index :members, :state
	end
end
