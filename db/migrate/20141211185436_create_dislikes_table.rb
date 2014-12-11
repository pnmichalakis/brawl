class CreateDislikesTable < ActiveRecord::Migration
  def change
  	  create_table :dislikes do |t|
  		t.integer :user_id
  		t.integer :opponent_fb_id

  		t.timestamps
  	end
  end
end
