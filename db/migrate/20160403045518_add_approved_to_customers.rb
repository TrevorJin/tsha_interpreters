class AddApprovedToCustomers < ActiveRecord::Migration[4.2]
  def change
  	add_column :customers, :approved, :boolean, default: false
  	add_column :customers, :approved_at, :datetime
  end
end
