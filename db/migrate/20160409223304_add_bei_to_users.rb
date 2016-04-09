class AddBeiToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :bei, :boolean, default: false
  	add_column :users, :bei_advanced, :boolean, default: false
  	add_column :users, :bei_master, :boolean, default: false
  end
end
