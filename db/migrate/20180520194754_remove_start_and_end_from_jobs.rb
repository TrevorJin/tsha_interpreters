class RemoveStartAndEndFromJobs < ActiveRecord::Migration[5.2]
  def change
  	remove_column :jobs, :start
  	remove_column :jobs, :end
  end
end
