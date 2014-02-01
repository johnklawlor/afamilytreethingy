class AddSpouseIdToMembers < ActiveRecord::Migration
	def change
		add_column :members, :spouse_id, :integer
	end
end
