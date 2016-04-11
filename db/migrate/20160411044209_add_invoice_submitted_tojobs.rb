class AddInvoiceSubmittedTojobs < ActiveRecord::Migration
  def change
  	add_column :jobs, :invoice_submitted, :boolean, default: false
  	add_column :jobs, :invoice_submitted_at, :datetime
  end
end
