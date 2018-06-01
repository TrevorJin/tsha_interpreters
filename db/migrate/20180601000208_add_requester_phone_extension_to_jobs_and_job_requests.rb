class AddRequesterPhoneExtensionToJobsAndJobRequests < ActiveRecord::Migration[5.2]
  def change
  	add_column :jobs, :requester_phone_number_extension, :string
  	add_column :job_requests, :requester_phone_number_extension, :string
  end
end
