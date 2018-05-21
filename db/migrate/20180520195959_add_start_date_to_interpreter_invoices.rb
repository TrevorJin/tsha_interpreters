class AddStartDateToInterpreterInvoices < ActiveRecord::Migration[5.2]
  def change
  	add_column :interpreter_invoices, :start_date, :date
  end
end
