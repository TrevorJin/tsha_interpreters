class AddMoreRatesToInterpreterInvoices < ActiveRecord::Migration[4.2]
  def change
  	add_column :interpreter_invoices, :extra_miles, :decimal
  	add_column :interpreter_invoices, :extra_mile_rate, :decimal
  	add_column :interpreter_invoices, :extra_interpreting_hours, :decimal
  	add_column :interpreter_invoices, :extra_interpreting_rate, :decimal
  end
end
