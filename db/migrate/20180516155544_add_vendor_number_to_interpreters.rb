class AddVendorNumberToInterpreters < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :vendor_number, :integer, unique: true
  end
end
