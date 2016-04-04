class AddCustomerIdToJobRequests < ActiveRecord::Migration
  def change
  	add_reference :job_requests, :customer, index: true, foreign_key: true
  end
end
