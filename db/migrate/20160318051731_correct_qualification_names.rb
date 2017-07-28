class CorrectQualificationNames < ActiveRecord::Migration[4.2]
  def change
  	add_column :users, :qast_1_interpreting, :boolean, default: false
  	add_column :users, :qast_2_interpreting, :boolean, default: false
  	add_column :users, :qast_3_interpreting, :boolean, default: false
  	add_column :users, :qast_4_interpreting, :boolean, default: false
  	add_column :users, :qast_5_interpreting, :boolean, default: false
  	add_column :users, :qast_1_transliterating, :boolean, default: false
  	add_column :users, :qast_2_transliterating, :boolean, default: false
  	add_column :users, :qast_3_transliterating, :boolean, default: false
  	add_column :users, :qast_4_transliterating, :boolean, default: false
  	add_column :users, :qast_5_transliterating, :boolean, default: false
  	add_column :users, :rid_ci, :boolean, default: false
  	add_column :users, :rid_ct, :boolean, default: false
  	add_column :users, :rid_cdi, :boolean, default: false
  	add_column :users, :di, :boolean, default: false
  	add_column :users, :nic, :boolean, default: false
  	add_column :users, :nic_advanced, :boolean, default: false
  	add_column :users, :nic_master, :boolean, default: false
  	add_column :users, :rid_sc_l, :boolean, default: false
  end
end
