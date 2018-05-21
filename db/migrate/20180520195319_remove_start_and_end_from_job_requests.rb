class RemoveStartAndEndFromJobRequests < ActiveRecord::Migration[5.2]
  def change
  	remove_column :job_requests, :start
  	remove_column :job_requests, :end
  end
end
