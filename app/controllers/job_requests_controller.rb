class JobRequestsController < ApplicationController
  before_action :manager_user, only: [:pending_job_requests]
  before_action :manager_or_customer, only: [:index, :show, :new, :create,
                                             :edit, :update, :destroy]
  before_action :active_or_manager_user, only: [:show, :new, :create, :edit,
                                                :update, :destroy]
  before_action :manager_dashboard, only: [:index, :show, :pending_job_requests]
  before_action :customer_dashboard, only: [:index, :show, :new, :create]
  before_action :update_job_and_job_request_statuses, only: [:index, :show,
                                                             :new, :create,
                                                             :edit, :update,
                                                             :destroy,
                                                             :pending_job_requests]

  def index
    # Manager Search
    if current_user && current_user.manager?
      if params[:search]
        @job_requests_not_awaiting_approval = JobRequest.search(params[:search], params[:page]).order(end: :desc).where(awaiting_approval: false)
      else
        @job_requests_not_awaiting_approval = JobRequest.paginate(page: params[:page]).order(end: :desc).where(awaiting_approval: false)
      end
    elsif current_customer
      @job_requests = current_customer.job_requests.order(end: :desc)
    end
  end

  def show
    @job_request = JobRequest.find(params[:id])
  end

  def new
    @job_request = JobRequest.new
  end

  def create
    @job_request = JobRequest.new(job_request_params)
    @job_request.customer = current_customer
    if @job_request.save
      flash[:info] = 'Job Request has been successfully submitted.'
      redirect_to job_requests_url
    else
      render 'new'
    end
  end

  def edit    
    @job_request = JobRequest.find(params[:id])
  end

  def update
    @job_request = JobRequest.find(params[:id])
    if @job_request.update_attributes(job_request_params)
      flash[:success] = 'Job request updated'
      redirect_to @job_request
    else
      render 'edit'
    end
  end

  def destroy
    JobRequest.find(params[:id]).destroy
    flash[:success] = 'Job Request deleted'
    redirect_to job_requests_url
  end

  def pending_job_requests
    # Manager Search
    if current_user && current_user.manager?
      if params[:search]
        @job_requests_awaiting_approval = JobRequest.search(params[:search], params[:page]).order(end: :desc).where(awaiting_approval: true)
      else
        @job_requests_awaiting_approval = JobRequest.paginate(page: params[:page]).order(end: :desc).where(awaiting_approval: true)
      end
    end
  end

  private

  def job_request_params
    params.require(:job_request).permit(:requester_first_name, :requester_last_name,
                                        :office_business_name, :requester_email,
                                        :requester_phone_number, :requester_fax_number, 
                                        :start, :end, :deaf_client_first_name,
                                        :deaf_client_last_name, :contact_person_first_name,
                                        :contact_person_last_name,
                                        :event_location_address_line_1,
                                        :event_location_address_line_2,
                                        :event_location_address_line_3, :city, :state,
                                        :zip, :office_phone_number,
                                        :type_of_appointment_situation, :message,
                                        :customer_id)
  end

  # Before filters

  # Confirms a manager user.
  def manager_user
    redirect_to(root_url) unless current_user.manager?
  end

  # Confirms either a manager user or customer.
  def manager_or_customer
    if current_user && current_user.manager?
      # Do Nothing
    elsif current_customer
      # Do Nothing
    else
      store_location
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end

  # Confirms the customer is activated if not a manager user.
  def active_or_manager_user
    if (current_customer && !current_customer.active?)
      redirect_to(job_requests_url)
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
      @confirmed_jobs = []
      @jobs_awaiting_completion = []
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

  # Provides a customer dashboard for a customer.
  def customer_dashboard
    if current_customer
      @pending_job_requests = JobRequest.where('customer_id = ? AND awaiting_approval = ?', current_customer.id, true)
      @approved_job_requests = JobRequest.where('customer_id = ? AND awaiting_approval = ? AND accepted = ?', current_customer.id, false, true)
      @rejected_job_requests = JobRequest.where('customer_id = ? AND awaiting_approval = ? AND denied = ?', current_customer.id, false, true)
      @expired_job_requests = JobRequest.where('customer_id = ? AND awaiting_approval = ? AND expired = ?', current_customer.id, false, true)
      @total_job_requests = JobRequest.where('customer_id = ?', current_customer.id)
      @customer = current_customer
      @current_jobs = Job.joins(:confirmed_interpreters).where('customer_id = ? AND  completed = ?', current_customer.id, false)
      @completed_jobs = Job.joins(:completing_interpreters).where('customer_id = ? AND completed = ?', current_customer.id, true)

      @customer_jobs = Job.where('customer_id= ?', current_customer.id)
      @pending_jobs = []
      @customer_jobs.each do |customer_job|
        if !customer_job.confirmed_interpreters.any? && !customer_job.expired?
          @pending_jobs.push customer_job
        end
      end
      @manager_invoices = []
      @customer_jobs = current_customer.jobs
      @customer_jobs.each do |customer_job|
        customer_job.manager_invoices.each do |manager_invoice|
          @manager_invoices.push manager_invoice
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
