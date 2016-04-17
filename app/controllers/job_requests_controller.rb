class JobRequestsController < ApplicationController
  before_action :manager_user, only: [:pending_job_requests]
  before_action :manager_or_customer, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :update_job_and_job_request_statuses, only: [:index, :show, :new, :pending_job_requests]

  def index
    # Manager Dashboard
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
      @jobs_with_interpreter_assigned.each do |job|
        if Time.now < job.start
          confirmed_jobs.push job
        end
      end
      @jobs_awaiting_completion = Job.where(has_interpreter_assigned: true, completed: false).order(end: :desc)
      @jobs_awaiting_invoice = Job.where(has_interpreter_assigned: true, invoice_submitted: false, completed: true).order(end: :desc)
      @expired_jobs = Job.where(expired: true).order(end: :desc)
      @total_jobs = Job.all.order(end: :desc)
    end

    # Interpreter Dashboard
    if current_user && !current_user.manager?
      @user = current_user
      @user_jobs = @user.eligible_jobs
      @current_jobs = @user.confirmed_jobs.where(has_interpreter_assigned: true)
      @pending_jobs = @user.attempted_jobs
      @completed_jobs = @user.completed_jobs
      @rejected_jobs = @user.rejected_jobs
    end

    if current_customer
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

    if current_customer
      @customer = current_customer
      @job_requests = JobRequest.where(customer_id: @customer.id).order(id: :desc)
      @pending_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ?", @customer.id, true)
      @approved_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND accepted = ?", @customer.id, false, true)
      @rejected_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND denied = ?", @customer.id, false, true)
      @expired_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND expired = ?", @customer.id, false, true)
      @total_job_requests = JobRequest.where("customer_id = ?", @customer.id)
    end

    # Manager Search
    if current_user && current_user.manager?
      if params[:search]
        @job_requests_not_awaiting_approval = JobRequest.search(params[:search], params[:page]).order(end: :desc).where(awaiting_approval: false)
      else
        @job_requests_not_awaiting_approval = JobRequest.paginate(page: params[:page]).order(end: :desc).where(awaiting_approval: false)
      end
    end
  end

  def show
    # Manager Dashboard
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
      @jobs_with_interpreter_assigned.each do |job|
        if Time.now < job.start
          confirmed_jobs.push job
        end
      end
      @jobs_awaiting_completion = Job.where(has_interpreter_assigned: true, completed: false).order(end: :desc)
      @jobs_awaiting_invoice = Job.where(has_interpreter_assigned: true, invoice_submitted: false, completed: true).order(end: :desc)
      @expired_jobs = Job.where(expired: true).order(end: :desc)
      @total_jobs = Job.all.order(end: :desc)
    end

    # Interpreter Dashboard
    if current_user && !current_user.manager?
      @user = current_user
      @user_jobs = @user.eligible_jobs
      @current_jobs = @user.confirmed_jobs.where(has_interpreter_assigned: true)
      @pending_jobs = @user.attempted_jobs
      @completed_jobs = @user.completed_jobs
      @rejected_jobs = @user.rejected_jobs
    end

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

    @job_request = JobRequest.find(params[:id])
  end

  def new
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
    
  	@job_request = JobRequest.new
  end

  def create
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

    @job_request = JobRequest.new(job_request_params)
    @job_request.customer = current_customer
    if @job_request.save
      flash[:info] = "Job Request has been successfully submitted."
      redirect_to job_requests_url
    else
      render 'new'
    end
  end

  def edit
    # @pending_users = User.where(approved: false)
    # @total_users = User.all
    # @total_customers = Customer.all
    # @pending_customers = Customer.where(approved: false)
    
    @job_request = JobRequest.find(params[:id])
  end

  def update
    @job_request = JobRequest.find(params[:id])
    if @job_request.update_attributes(job_request_params)
      flash[:success] = "Job request updated"
      redirect_to @job_request
    else
      render 'edit'
    end
  end

  def destroy
    JobRequest.find(params[:id]).destroy
    flash[:success] = "Job Request deleted"
    redirect_to job_requests_url
  end

  def pending_job_requests
    # Manager Dashboard
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
      @jobs_with_interpreter_assigned.each do |job|
        if Time.now < job.start
          confirmed_jobs.push job
        end
      end
      @jobs_awaiting_completion = Job.where(has_interpreter_assigned: true, completed: false).order(end: :desc)
      @jobs_awaiting_invoice = Job.where(has_interpreter_assigned: true, invoice_submitted: false, completed: true).order(end: :desc)
      @expired_jobs = Job.where(expired: true).order(end: :desc)
      @total_jobs = Job.all.order(end: :desc)
    end

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
      params.require(:job_request).permit(:requester_first_name, :requester_last_name, :office_business_name,
                                          :requester_email, :requester_phone_number, :requester_fax_number, 
                                          :start, :end, :deaf_client_first_name, :deaf_client_last_name, 
                                          :contact_person_first_name, :contact_person_last_name,
                                          :event_location_address_line_1, :event_location_address_line_2,
                                          :event_location_address_line_3, :city, :state, :zip, :office_phone_number,
                                          :type_of_appointment_situation, :message, :customer_id)
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
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Marks jobs and job requests as expired or completed based on the time.
    def update_job_and_job_request_statuses
      mark_expired_jobs
      mark_expired_job_requests
      mark_completed_jobs
    end
end
