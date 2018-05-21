class AddStartAndEndTimeToJobRequests < ActiveRecord::Migration[5.2]
  def change
  	add_column :job_requests, :start_time, :datetime
  	add_column :job_requests, :requested_end_time, :datetime
  end
end
