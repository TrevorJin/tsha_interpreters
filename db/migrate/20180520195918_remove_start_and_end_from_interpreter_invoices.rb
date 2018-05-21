class RemoveStartAndEndFromInterpreterInvoices < ActiveRecord::Migration[5.2]
  def change
  	remove_column :interpreter_invoices, :start
  	remove_column :interpreter_invoices, :end
  end
end
