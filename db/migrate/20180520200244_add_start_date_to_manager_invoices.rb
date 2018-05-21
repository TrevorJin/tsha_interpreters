class AddStartDateToManagerInvoices < ActiveRecord::Migration[5.2]
  def change
  	add_column :manager_invoices, :start_date, :date
  end
end
