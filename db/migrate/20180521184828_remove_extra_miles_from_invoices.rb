class RemoveExtraMilesFromInvoices < ActiveRecord::Migration[5.2]
  def change
  	remove_column :interpreter_invoices, :extra_miles
  	remove_column :interpreter_invoices, :extra_mile_rate
  	remove_column :manager_invoices, :extra_miles
  	remove_column :manager_invoices, :extra_mile_rate
  end
end
