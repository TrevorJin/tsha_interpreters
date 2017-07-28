class ChangeCustomerColumnNameToContactFirstName < ActiveRecord::Migration[4.2]
  def change
  	rename_column :customers, :contact_name, :contact_first_name
  end
end
