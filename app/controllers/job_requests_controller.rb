class JobRequestsController < ApplicationController
  before_action :logged_in_user, only: [:pending_job_requests]
  before_action :manager_user, only: [:pending_job_requests]
  before_action :manager_or_customer, only: [:index, :show, :new, :create,
                                             :update]
  before_action :active_or_manager_user, only: [:show, :new, :create, :update]
  before_action :manager_dashboard, only: [:index, :show, :new,
                                           :pending_job_requests]
  before_action :customer_dashboard, only: [:index, :show, :new, :create]
  before_action :update_job_and_job_request_statuses, only: [:index, :show,
                                                             :new, :create,
                                                             :update,
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

  # Later feature
  # def edit    
  #   @job_request = JobRequest.find(params[:id])
  # end

  # def update
  #   @job_request = JobRequest.find(params[:id])
  #   if @job_request.update_attributes(job_request_params)
  #     flash[:success] = 'Job request updated'
  #     redirect_to @job_request
  #   else
  #     render 'edit'
  #   end
  # end

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

  # Confirms a logged-in user.
  def logged_in_user
    unless user_logged_in?
      store_location
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end

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
    if current_customer && !current_customer.active?
      redirect_to(job_requests_url)
    end
  end
end
