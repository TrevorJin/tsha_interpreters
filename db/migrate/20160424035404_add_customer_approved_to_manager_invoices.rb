class AddCustomerApprovedToManagerInvoices < ActiveRecord::Migration
  def change
  	add_column :manager_invoices, :customer_approved, :boolean, default: false
  	add_column :manager_invoices, :customer_approved_at, :datetime
  end
end
