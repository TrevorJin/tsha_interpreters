class AddRememberDigestToCustomers < ActiveRecord::Migration[4.2]
  def change
    add_column :customers, :remember_digest, :string
  end
end
