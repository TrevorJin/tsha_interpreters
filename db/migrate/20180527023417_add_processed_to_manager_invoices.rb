class AddProcessedToManagerInvoices < ActiveRecord::Migration[5.2]
  def change
  	add_column :manager_invoices, :processed, :boolean, default: false
  	add_column :manager_invoices, :processed_at, :datetime
  end
end
