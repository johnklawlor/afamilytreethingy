class AddShowHelpfulHintsToMembers < ActiveRecord::Migration
	def change
		add_column :members, :show_spacebar_hint, :boolean, default: true
	end
end
