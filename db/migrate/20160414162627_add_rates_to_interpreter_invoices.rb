class AddRatesToInterpreterInvoices < ActiveRecord::Migration[4.2]
  def change
  	add_column :interpreter_invoices, :miles, :decimal
  	add_column :interpreter_invoices, :mile_rate, :decimal
  	add_column :interpreter_invoices, :interpreting_hours, :decimal
  	add_column :interpreter_invoices, :interpreting_rate, :decimal
  end
end
