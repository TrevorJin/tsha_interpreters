class JobsController < ApplicationController
  before_action :logged_in_user, only: [:index, :new, :create, :new_job_from_job_request, :edit, :update,
                                        :destroy]
  before_action :manager_user,   only: [:new, :create, :new_job_from_job_request, :edit, :update, :destroy,
                                        :finalize_job_and_interpreters,
                                        :jobs_in_need_of_confirmation, :confirmed_jobs,
                                        :jobs_awaiting_completion, :jobs_awaiting_invoice,
                                        :processed_jobs, :expired_jobs]
  before_action :manager_correct_customer_or_interpreter, only: [:show]
  before_action :manager_dashboard, only: [:index, :show, :new, :new_job_from_job_request, :create, :edit,
                                           :jobs_in_need_of_confirmation, :confirmed_jobs, :jobs_awaiting_completion,
                                           :jobs_awaiting_invoice, :processed_jobs, :expired_jobs]
  before_action :interpreter_dashboard, only: [:index, :show, :new, :new_job_from_job_request, :create, :edit]
  before_action :customer_dashboard, only: [:show]
  before_action :update_job_and_job_request_statuses, only: [:index, :show, :new, :create, :new_job_from_job_request,
                                                             :jobs_in_need_of_confirmation, :confirmed_jobs,
                                                             :jobs_awaiting_completion, :jobs_awaiting_invoice,
                                                             :processed_jobs, :expired_jobs]

  def index
    if params[:search]
      @jobs = Job.search(params[:search], params[:page]).order(end: :desc)
    else
      @jobs = Job.paginate(page: params[:page]).order(end: :desc)
    end
  end

  def show
    @job = Job.find(params[:id])
    @attempted_interpreters = @job.attempted_interpreters
    @confirmed_interpreters = @job.confirmed_interpreters
  end

  def new
  	@job = Job.new
  end

  def new_job_from_job_request
    @job_request = JobRequest.find(params[:job_request_id])
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      flash[:info] = "Job has been successfully created."
      redirect_to jobs_url
    else
      render 'new'
    end
  end

  def edit
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

  def finalize_job_and_interpreters
    @job = Job.find(params[:id])
    @job.finalize_job_and_interpreters
    flash[:success] = "This job has been finalized."
    redirect_to job_url(@job)
  end

  def jobs_in_need_of_confirmation

  end

  def confirmed_jobs

  end

  def jobs_awaiting_completion

  end

  def jobs_awaiting_invoice
    
  end

  def processed_jobs

  end

  def expired_jobs
    
  end

  private

    def job_params
      params.require(:job).permit(:start, :end, :requester_first_name, :requester_last_name, 
                                  :requester_email, :requester_phone_number, :contact_person_first_name,
                                  :contact_person_last_name, :address_line_1, :address_line_2,
                                   :address_line_3, :city, :state, :zip, :invoice_notes,
                                   :notes_for_irp, :notes_for_interpreter, :directions, :customer_id,
                                   :qast_1_interpreting_required, :qast_2_interpreting_required,
                                   :qast_3_interpreting_required, :qast_4_interpreting_required,
                                   :qast_5_interpreting_required, :qast_1_transliterating_required_required,
                                   :qast_2_transliterating_required, :qast_3_transliterating_required,
                                   :qast_4_transliterating_required, :qast_5_transliterating_required,
                                   :rid_ci_required, :rid_ct_required, :rid_cdi_required, :di_required,
                                   :nic_required, :nic_advanced_required, :nic_master_required, 
                                   :rid_sc_l_required, :bei_required, :bei_advanced_required,
                                   :bei_master_required)
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

    # Confirms a manager user, correct customer, or correct interpreter.
    def manager_correct_customer_or_interpreter
      @job = Job.find(params[:id])
      if (current_user && current_user.manager?)
        # Do Nothing
      elsif (current_customer && current_customer.jobs.include?(@job))
        # Do Nothing
      elsif (current_user && current_user.confirmed_jobs.include?(@job))
        # Do Nothing
      else
        redirect_to root_url
      end
    end

    # Provides a manager dashboard for a manager.
    def manager_dashboard
      if current_user && current_user.manager?
        @pending_users = User.where(approved: false)
        @total_users = User.all
        @total_customers = Customer.all
        @pending_customers = Customer.where(approved: false)
        @job_requests_awaiting_approval = JobRequest.where(awaiting_approval: true).order(end: :desc)
        @job_requests_not_awaiting_approval = JobRequest.where(awaiting_approval: false).order(end: :desc)
        @job_requests = JobRequest.all.order(end: :desc)
        @jobs_in_need_of_confirmation = Job.where(has_interpreter_assigned: false, expired: false).order(end: :desc)
        @jobs_with_interpreter_assigned = Job.where(has_interpreter_assigned: true).order(end: :desc)
        @confirmed_jobs = Array.new
        @jobs_awaiting_completion = Array.new
        @jobs_with_interpreter_assigned.each do |job|
          if Time.now < job.start
            @confirmed_jobs.push job
          end
          if job.start > Time.now
            @jobs_awaiting_completion.push job
          end
        end
        @jobs_awaiting_invoice = Job.where(has_interpreter_assigned: true, invoice_submitted: false, completed: true).order(end: :desc)
        @processed_jobs = Job.where(has_interpreter_assigned: true, invoice_submitted: true, completed: true).order(end: :desc)
        @expired_jobs = Job.where(expired: true).order(end: :desc)
        @total_jobs = Job.all.order(end: :desc)
        @interpreter_invoices = InterpreterInvoice.all.order(end: :desc)
        @manager_invoices = ManagerInvoice.all.order(end: :desc)
      end
    end

    # Provides an interpreter dashboard for a regular user.
    def interpreter_dashboard
      if current_user && !current_user.manager?
        @user = current_user
        @user_jobs = @user.eligible_jobs
        @current_jobs = @user.confirmed_jobs.where(has_interpreter_assigned: true)
        @pending_jobs = @user.attempted_jobs
        @completed_jobs = @user.completed_jobs
        @rejected_jobs = @user.rejected_jobs
      end
    end

    # Provides a customer dashboard for a customer.
    def customer_dashboard
      if current_customer
        @pending_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ?", current_customer.id, true)
        @approved_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND accepted = ?", current_customer.id, false, true)
        @rejected_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND denied = ?", current_customer.id, false, true)
        @expired_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND expired = ?", current_customer.id, false, true)
        @total_job_requests = JobRequest.where("customer_id = ?", current_customer.id)
        @customer = current_customer
        @current_jobs = Job.joins(:confirmed_interpreters).where("customer_id = ?", current_customer.id)
        @completed_jobs = Job.joins(:completing_interpreters).where("customer_id = ?", current_customer.id)

        @customer_jobs = Job.where("customer_id= ?", current_customer.id)
        @pending_jobs = Array.new
        @customer_jobs.each do |customer_job|
          if (!customer_job.confirmed_interpreters.any? && !customer_job.expired?)
            @pending_jobs.push customer_job
          end
        end
      end
    end

    # Marks jobs and job requests as expired or completed based on the time.
    def update_job_and_job_request_statuses
      mark_expired_jobs
      mark_expired_job_requests
      mark_completed_jobs
    end
end
