class JobRequestsController < ApplicationController
  before_action :logged_in_user_or_customer, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  def index
    @pending_users = User.where(approved: false)
    @total_users = User.all
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @job_requests = JobRequest.all
    @total_jobs = Job.all

    if current_user
      @user = current_user
      @current_jobs = @user.confirmed_jobs
      @pending_jobs = @user.attempted_jobs
      @completed_jobs = @user.completed_jobs
      @rejected_jobs = @user.rejected_jobs
    elsif current_customer
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
      @job_requests = JobRequest.where(customer_id: @customer.id)
      @pending_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ?", @customer.id, true)
      @approved_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND accepted = ?", @customer.id, false, true)
      @rejected_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND denied = ?", @customer.id, false, true)
      @expired_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND expired = ?", @customer.id, false, true)
      @total_job_requests = JobRequest.where("customer_id = ?", @customer.id)
    elsif current_user && current_user.manager?
      @job_requests = JobRequest.all
      @job_requests_awaiting_approval = JobRequest.where(awaiting_approval: true)
      @job_requests_not_awaiting_approval = JobRequest.where(awaiting_approval: false)
    end
  end

  def show
    @pending_users = User.where(approved: false)
    @total_users = User.all
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @job_requests = JobRequest.all
    @total_jobs = Job.all

    @user = current_user
    @current_jobs = @user.confirmed_jobs
    @pending_jobs = @user.attempted_jobs
    @completed_jobs = @user.completed_jobs
    @rejected_jobs = @user.rejected_jobs

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
    # @pending_users = User.where(approved: false)
    # @total_users = User.all
    # @total_customers = Customer.all
    # @pending_customers = Customer.where(approved: false)

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

    # Confirms either a logged-in user or customer.
    def logged_in_user_or_customer
      unless user_logged_in? || customer_logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
