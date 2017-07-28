class AddCellPhoneToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :cell_phone, :string, limit: 30
  end
end
