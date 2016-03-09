class AddCustomerIdToJobs < ActiveRecord::Migration
  def change
  	add_reference :jobs, :customer, index: true, foreign_key: true
  end
end
