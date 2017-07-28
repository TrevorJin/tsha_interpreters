class AddResetToCustomers < ActiveRecord::Migration[4.2]
  def change
    add_column :customers, :reset_digest, :string
    add_column :customers, :reset_sent_at, :datetime
  end
end
