class AddTimesToInvoices < ActiveRecord::Migration[5.2]
  def change
  	add_column :interpreter_invoices, :start_time, :datetime
  	add_column :interpreter_invoices, :requested_end_time, :datetime
  	add_column :interpreter_invoices, :actual_end_time, :datetime
  	add_column :manager_invoices, :start_time, :datetime
  	add_column :manager_invoices, :requested_end_time, :datetime
  	add_column :manager_invoices, :actual_end_time, :datetime
  end
end
