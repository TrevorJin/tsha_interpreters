class AddFieldsToCustomers < ActiveRecord::Migration
  def change
  	add_column :customers, :contact_last_name, :string
    add_column :customers, :billing_address_line_1, :string
    add_column :customers, :billing_address_line_2, :string
    add_column :customers, :billing_address_line_3, :string
    add_column :customers, :mail_address_line_1, :string
    add_column :customers, :mail_address_line_2, :string
    add_column :customers, :mail_address_line_3, :string
    add_column :customers, :customer_name, :string
    add_column :customers, :phone_number, :string
    add_column :customers, :phone_number_extension, :string
    add_column :customers, :contact_phone_number, :string
    add_column :customers, :contact_phone_number_extension, :string
    add_column :customers, :email, :string
    add_column :customers, :fax, :string
  end
end
