class ReconfigureMatchesTable < ActiveRecord::Migration
  def change
  	remove_column :matches, :body
  end
end
