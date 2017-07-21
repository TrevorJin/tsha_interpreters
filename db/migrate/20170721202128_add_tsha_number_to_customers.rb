class AddTshaNumberToCustomers < ActiveRecord::Migration[5.0]
  def change
  	add_column :customers, :tsha_number, :integer
  end
end
