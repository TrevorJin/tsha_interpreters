class AddTimesToJobs < ActiveRecord::Migration[5.2]
  def change
  	add_column :jobs, :start_time, :datetime
  	add_column :jobs, :requested_end_time, :datetime
  	add_column :jobs, :actual_end_time, :datetime
  end
end
