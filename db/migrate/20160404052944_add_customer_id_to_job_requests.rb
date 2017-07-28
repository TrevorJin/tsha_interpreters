class AddCustomerIdToJobRequests < ActiveRecord::Migration[4.2]
  def change
  	add_reference :job_requests, :customer, index: true, foreign_key: true
  end
end
