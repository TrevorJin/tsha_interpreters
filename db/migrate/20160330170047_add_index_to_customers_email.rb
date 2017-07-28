class AddIndexToCustomersEmail < ActiveRecord::Migration[4.2]
  def change
  	add_index :customers, :email, unique: true
  end
end
