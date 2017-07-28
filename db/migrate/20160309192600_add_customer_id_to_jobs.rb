class AddCustomerIdToJobs < ActiveRecord::Migration[4.2]
  def change
  	add_reference :jobs, :customer, index: true, foreign_key: true
  end
end
