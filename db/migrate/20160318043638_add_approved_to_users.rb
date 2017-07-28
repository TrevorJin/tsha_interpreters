class AddApprovedToUsers < ActiveRecord::Migration[4.2]
  def change
  	add_column :users, :approved, :boolean, default: false
  	add_column :users, :approved_at, :datetime
  end
end
