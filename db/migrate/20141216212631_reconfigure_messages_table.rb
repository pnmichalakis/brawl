class ReconfigureMessagesTable < ActiveRecord::Migration
  def change
  	remove_column :messages, :recipient_id
  	add_column :messages, :recipient_id, :integer
  end
end
