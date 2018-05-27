class RemoveCustomerApprovedFromManagerInvoices < ActiveRecord::Migration[5.2]
  def change
  	remove_column :manager_invoices, :customer_approved
  	remove_column :manager_invoices, :customer_approved_at
  end
end
