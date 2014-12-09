class AddColumnsToUsersTable < ActiveRecord::Migration
  def change
  	add_column :users, :email, :string
  	add_column :users, :fbid, :string
  end
end
