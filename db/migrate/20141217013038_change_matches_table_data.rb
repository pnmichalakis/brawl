class ChangeMatchesTableData < ActiveRecord::Migration
  def change
  	remove_column :matches, :user_id1
  	remove_column :matches, :user_id2
  	add_column :matches, :user_id, :integer
  	add_column :matches, :opponent_id, :integer
  end
end
