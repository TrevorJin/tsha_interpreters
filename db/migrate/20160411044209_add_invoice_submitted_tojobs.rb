class AddInvoiceSubmittedTojobs < ActiveRecord::Migration[4.2]
  def change
  	add_column :jobs, :invoice_submitted, :boolean, default: false
  	add_column :jobs, :invoice_submitted_at, :datetime
  end
end
