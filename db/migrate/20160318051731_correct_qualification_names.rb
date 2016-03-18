class CorrectQualificationNames < ActiveRecord::Migration
  def change
  	remove_column :users, :QAST_1_interpreting
  	remove_column :users, :QAST_2_interpreting
  	remove_column :users, :QAST_3_interpreting
  	remove_column :users, :QAST_4_interpreting
  	remove_column :users, :QAST_5_interpreting
  	remove_column :users, :QAST_1_transliterating
  	remove_column :users, :QAST_2_transliterating
  	remove_column :users, :QAST_3_transliterating
  	remove_column :users, :QAST_4_transliterating
  	remove_column :users, :QAST_5_transliterating
  	remove_column :users, :RID_CI
  	remove_column :users, :RID_CT
  	remove_column :users, :RID_CDI
  	remove_column :users, :DI
  	remove_column :users, :NIC
  	remove_column :users, :NIC_advanced
  	remove_column :users, :NIC_master
  	remove_column :users, :RID_SC_L
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
