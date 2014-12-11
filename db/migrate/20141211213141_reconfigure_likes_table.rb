class ReconfigureLikesTable < ActiveRecord::Migration
  def change
  	change_column :likes, :opponent_fb_id, :bigint
  	change_column :dislikes, :opponent_fb_id, :bigint
  end
end
