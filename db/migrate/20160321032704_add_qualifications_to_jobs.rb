class AddQualificationsToJobs < ActiveRecord::Migration
  def change
  	add_column :jobs, :qast_1_interpreting_required, :boolean, default: false
  	add_column :jobs, :qast_2_interpreting_required, :boolean, default: false
  	add_column :jobs, :qast_3_interpreting_required, :boolean, default: false
  	add_column :jobs, :qast_4_interpreting_required, :boolean, default: false
  	add_column :jobs, :qast_5_interpreting_required, :boolean, default: false
  	add_column :jobs, :qast_1_transliterating_required_required, :boolean, default: false
  	add_column :jobs, :qast_2_transliterating_required, :boolean, default: false
  	add_column :jobs, :qast_3_transliterating_required, :boolean, default: false
  	add_column :jobs, :qast_4_transliterating_required, :boolean, default: false
  	add_column :jobs, :qast_5_transliterating_required, :boolean, default: false
  	add_column :jobs, :rid_ci_required, :boolean, default: false
  	add_column :jobs, :rid_ct_required, :boolean, default: false
  	add_column :jobs, :rid_cdi_required, :boolean, default: false
  	add_column :jobs, :di_required, :boolean, default: false
  	add_column :jobs, :nic_required, :boolean, default: false
  	add_column :jobs, :nic_advanced_required, :boolean, default: false
  	add_column :jobs, :nic_master_required, :boolean, default: false
  	add_column :jobs, :rid_sc_l_required, :boolean, default: false
  end
end
