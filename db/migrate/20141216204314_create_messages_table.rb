class CreateMessagesTable < ActiveRecord::Migration
  def change
  	create_table :messages do |t|
  		t.integer :sender_id
    	t.string :recipient_id
    	t.text :body

    	t.timestamps
    end
  end
end
