class ChangeLikesOpponentColumn < ActiveRecord::Migration
  def change
  	add_column :likes, :opponent_id, :integer
  	remove_column :likes, :opponent_fb_id
  	add_column :dislikes, :opponent_id, :integer
  	remove_column :dislikes, :opponent_fb_id
  end
end
