class RemoveStartAndEndFromManagerInvoices < ActiveRecord::Migration[5.2]
  def change
  	remove_column :manager_invoices, :start
  	remove_column :manager_invoices, :end
  end
end
