class AddBeiToJobs < ActiveRecord::Migration[4.2]
  def change
  	add_column :jobs, :bei_required, :boolean, default: false
  	add_column :jobs, :bei_advanced_required, :boolean, default: false
  	add_column :jobs, :bei_master_required, :boolean, default: false
  end
end
