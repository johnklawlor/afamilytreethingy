class CreateSpouseRelationships < ActiveRecord::Migration
  def change
    create_table :spouse_relationships do |t|
      t.integer :member_id
      t.integer :spouse_id

      t.timestamps
    end
  end
end
