class AddCellPhoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cell_phone, :string, limit: 30
  end
end
