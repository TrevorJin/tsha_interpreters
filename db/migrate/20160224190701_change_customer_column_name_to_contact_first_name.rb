class ChangeCustomerColumnNameToContactFirstName < ActiveRecord::Migration
  def change
  	rename_column :customers, :contact_name, :contact_first_name
  end
end
