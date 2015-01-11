class AddUnseenColumnToMatches < ActiveRecord::Migration
  def change
  	add_column :matches, :seen, :boolean
  end
end
