class AddStartDateToJobRequests < ActiveRecord::Migration[5.2]
  def change
  	add_column :job_requests, :start_date, :date
  end
end
