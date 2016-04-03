class AddRememberDigestToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :remember_digest, :string
  end
end
