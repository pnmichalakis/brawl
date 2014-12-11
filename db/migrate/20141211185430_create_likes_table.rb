class CreateLikesTable < ActiveRecord::Migration
  def change
  		create_table :likes do |t|
  		t.integer :user_id
  		t.integer :opponent_fb_id

  		t.timestamps
  	end
  end
end
