class AddFundNumberToCustomers < ActiveRecord::Migration[5.0]
  def change
  	add_column :customers, :fund_number, :integer
  end
end
