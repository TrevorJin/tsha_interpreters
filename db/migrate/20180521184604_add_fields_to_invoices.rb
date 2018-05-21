class AddFieldsToInvoices < ActiveRecord::Migration[5.2]
  def change
  	add_column :interpreter_invoices, :misc_travel, :decimal
  	add_column :interpreter_invoices, :legal_hours, :decimal
  	add_column :interpreter_invoices, :legal_rate, :decimal
  	add_column :interpreter_invoices, :extra_legal_hours, :decimal
  	add_column :interpreter_invoices, :extra_legal_rate, :decimal
  	add_column :manager_invoices, :misc_travel, :decimal
  	add_column :manager_invoices, :legal_hours, :decimal
  	add_column :manager_invoices, :legal_rate, :decimal
  	add_column :manager_invoices, :extra_legal_hours, :decimal
  	add_column :manager_invoices, :extra_legal_rate, :decimal
  end
end
