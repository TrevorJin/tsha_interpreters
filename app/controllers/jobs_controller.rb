class JobsController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :manager_user,   only: [:edit, :update, :destroy]

  def index
    @pending_users = User.where(approved: false)
    @total_users = User.all
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @job_requests = JobRequest.all
    @total_jobs = Job.all

    @jobs = Job.all
  end

  def show
    @pending_users = User.where(approved: false)
    @total_users = User.all
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @job_requests = JobRequest.all
    @total_jobs = Job.all

    @job = Job.find(params[:id])
  end

  def new
    @pending_users = User.where(approved: false)
    @total_users = User.all
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @job_requests = JobRequest.all
    @total_jobs = Job.all

  	@job = Job.new
  end

  def new_job_from_job_request
    @pending_users = User.where(approved: false)
    @total_users = User.all
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @job_requests = JobRequest.all
    @total_jobs = Job.all

    @job_request = JobRequest.find(params[:job_request_id])
    @job = Job.new
  end

  def create
    @pending_users = User.where(approved: false)
    @total_users = User.all
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @job_requests = JobRequest.all
    @total_jobs = Job.all

    @job = Job.new(job_params)
    if @job.save
      flash[:info] = "Job has been successfully created."
      redirect_to jobs_url
    else
      render 'new'
    end
  end

  def edit
    @pending_users = User.where(approved: false)
    @total_users = User.all
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @job_requests = JobRequest.all
    @total_jobs = Job.all
    
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])
    if @job.update_attributes(job_params)
      flash[:success] = "Job updated"
      redirect_to @job
    else
      render 'edit'
    end
  end

  def destroy
    Job.find(params[:id]).destroy
    flash[:success] = "Job deleted"
    redirect_to jobs_url
  end

  private

    def job_params
      params.require(:job).permit(:start, :end, :address_line_1, :address_line_2,
                                   :address_line_3, :city, :state, :zip, :invoice_notes,
                                   :notes_for_irp, :notes_for_interpreter, :directions, :customer_id,
                                   :qast_1_interpreting_required, :qast_2_interpreting_required,
                                   :qast_3_interpreting_required, :qast_4_interpreting_required,
                                   :qast_5_interpreting_required, :qast_1_transliterating_required_required,
                                   :qast_2_transliterating_required, :qast_3_transliterating_required,
                                   :qast_4_transliterating_required, :qast_5_transliterating_required,
                                   :rid_ci_required, :rid_ct_required, :rid_cdi_required, :di_required,
                                   :nic_required, :nic_advanced_required, :nic_master_required, 
                                   :rid_sc_l_required)
    end

    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless user_logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms a manager user.
    def manager_user
      redirect_to(root_url) unless current_user.manager?
    end
end
