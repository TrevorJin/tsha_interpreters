class JobRequestsController < ApplicationController
  before_action :logged_in_user_or_customer, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  def index
    @pending_users = User.where(approved: false)
    @total_users = User.all
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @job_requests = JobRequest.all
    @total_jobs = Job.all

    if current_customer
      @customer = current_customer
      @job_requests = JobRequest.where(customer_id: @customer.id)
      @pending_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ?", @customer.id, true)
    elsif current_user && current_user.manager?
      @job_requests = JobRequest.all
      @job_requests_awaiting_approval = JobRequest.where(awaiting_approval: true)
      @approved_job_requests = JobRequest.where(awaiting_approval: false)
    end
  end

  def show
    @pending_users = User.where(approved: false)
    @total_users = User.all
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @job_requests = JobRequest.all
    @total_jobs = Job.all

    @job_request = JobRequest.find(params[:id])
  end

  def new
    # @pending_users = User.where(approved: false)
    # @total_users = User.all
    # @total_customers = Customer.all
    # @pending_customers = Customer.where(approved: false)
    
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
