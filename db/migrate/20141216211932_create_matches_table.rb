class CreateMatchesTable < ActiveRecord::Migration
  def change
  	  create_table :matches do |t|
  		t.integer :user_id1
    	t.integer :user_id2
    	t.text :body

    	t.timestamps
    end
  end
end
