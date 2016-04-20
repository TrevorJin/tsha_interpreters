class AddJobCompletedToInterpreterInvoice < ActiveRecord::Migration
  def change
  	add_column :interpreter_invoices, :job_completed, :boolean, default: false
  	add_column :interpreter_invoices, :job_completed_at, :datetime
  end
end
