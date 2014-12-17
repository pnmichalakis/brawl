class AddMoreColumnsToUsersTable < ActiveRecord::Migration
  def change
  	add_column :users, :height, :text
  	add_column :users, :weight, :integer
  	add_column :users, :location, :text
  end
end
