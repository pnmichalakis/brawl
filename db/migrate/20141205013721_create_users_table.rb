class CreateUsersTable < ActiveRecord::Migration
  def change
  		create_table :users do |t|
  		t.string :name, null: false
    	t.string :dob
    	t.string :picture
    	t.string :bio

    	t.timestamps
    end
  end
end
