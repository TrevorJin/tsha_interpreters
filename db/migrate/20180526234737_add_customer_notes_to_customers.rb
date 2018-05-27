class AddCustomerNotesToCustomers < ActiveRecord::Migration[5.2]
  def change
  	add_column :customers, :customer_notes, :text
  end
end
