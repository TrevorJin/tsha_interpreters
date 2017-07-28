class AddJobCompletedToInterpreterInvoice < ActiveRecord::Migration[4.2]
  def change
  	add_column :interpreter_invoices, :job_completed, :boolean, default: false
  	add_column :interpreter_invoices, :job_completed_at, :datetime
  end
end
