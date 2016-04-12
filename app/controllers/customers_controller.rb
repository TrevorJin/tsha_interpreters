class CustomersController < ApplicationController
  before_action :logged_in_user, only: [:index, :pending_customers, :destroy, :approve_account, :deactivate_customer]
  before_action :logged_in_customer, only: [:pending_approval, :approved_job_requests, :rejected_job_requests,
                                            :expired_job_requests]
  before_action :manager_user,   only: [:index, :pending_customers, :approve_account]
  before_action :admin_user, only: [:destroy, :deactivate_customer]
  before_action :logged_in_user_or_customer, only: [:show, :edit, :update]
  before_action :correct_customer, only: [:pending_approval, :approved_job_requests, :rejected_job_requests,
                                          :expired_job_requests]
  before_action :correct_customer_or_manager_user, only: [:show, :edit, :update]
  before_action :update_job_and_job_request_statuses, only: [:pending_approval, :approved_job_requests,
                                                              :rejected_job_requests, :expired_job_requests,
                                                              :index, :show, :new, :pending_customers]

  def index
    # Manager Dashboard
    if current_user && current_user.manager?
      @pending_users = User.where(approved: false)
      @total_users = User.all
      @total_customers = Customer.all
      @pending_customers = Customer.where(approved: false)
      @job_requests = JobRequest.all
      @total_jobs = Job.all
    end

    if params[:search]
      @customers = Customer.search(params[:search], params[:page]).order(customer_name: :asc)
    else
      @customers = Customer.paginate(page: params[:page]).order(customer_name: :asc)
    end
  end

  def show
    # Manager Dashboard
    if current_user && current_user.manager?
      @pending_users = User.where(approved: false)
      @total_users = User.all
      @total_customers = Customer.all
      @pending_customers = Customer.where(approved: false)
      @job_requests = JobRequest.all
      @total_jobs = Job.all
    end

    # Customer Dashboard
    if current_customer
      @pending_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ?", current_customer.id, true)
      @approved_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND accepted = ?", current_customer.id, false, true)
      @rejected_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND denied = ?", current_customer.id, false, true)
      @expired_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND expired = ?", current_customer.id, false, true)
      @total_job_requests = JobRequest.where("customer_id = ?", current_customer.id)
      @current_jobs = Job.joins(:confirmed_interpreters).where("customer_id = ?", current_customer.id)
      @completed_jobs = Job.joins(:completing_interpreters).where("customer_id = ?", current_customer.id)

      @customer_jobs = Job.where("customer_id = ?", current_customer.id)
      @pending_jobs = Array.new
      @customer_jobs.each do |customer_job|
        if (!customer_job.confirmed_interpreters.any? && !customer_job.expired?)
          @pending_jobs.push customer_job
        end
      end
    end

    @customer = Customer.find(params[:id])
  end

  def new
    # Manager Dashboard
    if current_user && current_user.manager?
      @pending_users = User.where(approved: false)
      @total_users = User.all
      @total_customers = Customer.all
      @pending_customers = Customer.where(approved: false)
      @job_requests = JobRequest.all
      @total_jobs = Job.all
    end

    # Interpreter Dashboard
    if current_user && !current_user.manager?
      @user = current_user
      @current_jobs = @user.confirmed_jobs.where(has_interpreter_assigned: true)
      @pending_jobs = @user.attempted_jobs
      @completed_jobs = @user.completed_jobs
      @rejected_jobs = @user.rejected_jobs
    end

    # Customer Dashboard
    if current_customer
      @pending_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ?", current_customer.id, true)
      @approved_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND accepted = ?", current_customer.id, false, true)
      @rejected_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND denied = ?", current_customer.id, false, true)
      @expired_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND expired = ?", current_customer.id, false, true)
      @total_job_requests = JobRequest.where("customer_id = ?", current_customer.id)
      @current_jobs = Job.joins(:confirmed_interpreters).where("customer_id = ?", current_customer.id)
      @completed_jobs = Job.joins(:completing_interpreters).where("customer_id = ?", current_customer.id)

      @customer_jobs = Job.where("customer_id = ?", current_customer.id)
      @pending_jobs = Array.new
      @customer_jobs.each do |customer_job|
        if (!customer_job.confirmed_interpreters.any? && !customer_job.expired?)
          @pending_jobs.push customer_job
        end
      end
    end

    @customer = Customer.new
  end

  def create
    # Manager Dashboard
    if current_user && current_user.manager?
      @pending_users = User.where(approved: false)
      @total_users = User.all
      @total_customers = Customer.all
      @pending_customers = Customer.where(approved: false)
      @job_requests = JobRequest.all
      @total_jobs = Job.all
    end

    # Interpreter Dashboard
    if current_user
      @user = current_user
      @current_jobs = @user.confirmed_jobs.where(has_interpreter_assigned: true)
      @pending_jobs = @user.attempted_jobs
      @completed_jobs = @user.completed_jobs
      @rejected_jobs = @user.rejected_jobs
    end

    # Customer Dashboard
    if current_customer
      @pending_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ?", current_customer.id, true)
      @approved_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND accepted = ?", current_customer.id, false, true)
      @rejected_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND denied = ?", current_customer.id, false, true)
      @expired_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND expired = ?", current_customer.id, false, true)
      @total_job_requests = JobRequest.where("customer_id = ?", current_customer.id)
      @current_jobs = Job.joins(:confirmed_interpreters).where("customer_id = ?", current_customer.id)
      @completed_jobs = Job.joins(:completing_interpreters).where("customer_id = ?", current_customer.id)

      @customer_jobs = Job.where("customer_id = ?", current_customer.id)
      @pending_jobs = Array.new
      @customer_jobs.each do |customer_job|
        if (!customer_job.confirmed_interpreters.any? && !customer_job.expired?)
          @pending_jobs.push customer_job
        end
      end
    end

    @customer = Customer.new(customer_params)
    if @customer.save
      @customer.send_activation_email
      flash[:info] = "An email has been sent to activate this account."
      if user_logged_in? && current_user.manager?
        redirect_to new_customer_url
      else
        redirect_to root_url
      end
    else
      render 'new'
    end
  end

  def edit
    # Manager Dashboard
    if current_user && current_user.manager?
      @pending_users = User.where(approved: false)
      @total_users = User.all
      @total_customers = Customer.all
      @pending_customers = Customer.where(approved: false)
      @job_requests = JobRequest.all
      @total_jobs = Job.all
    end

    # Customer Dashboard
    if current_customer
      @pending_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ?", current_customer.id, true)
      @approved_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND accepted = ?", current_customer.id, false, true)
      @rejected_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND denied = ?", current_customer.id, false, true)
      @expired_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND expired = ?", current_customer.id, false, true)
      @total_job_requests = JobRequest.where("customer_id = ?", current_customer.id)
      @current_jobs = Job.joins(:confirmed_interpreters).where("customer_id = ?", current_customer.id)
      @completed_jobs = Job.joins(:completing_interpreters).where("customer_id = ?", current_customer.id)

      @customer_jobs = Job.where("customer_id = ?", current_customer.id)
      @pending_jobs = Array.new
      @customer_jobs.each do |customer_job|
        if (!customer_job.confirmed_interpreters.any? && !customer_job.expired?)
          @pending_jobs.push customer_job
        end
      end
    end
    
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update_attributes(customer_params)
      flash[:success] = "Profile updated"
      redirect_to @customer
    else
      render 'edit'
    end
  end

  # The only account destruction will be for customers trying to have their new account accepted.
  # Any existing customer that should be blocked will be put into a "deactivated" state instead of
  # being destroyed for record keeping purposes. We do not want to lose their history with TSHA.
  def destroy
    @customer = Customer.find(params[:id])
    @customer.send_account_denied_email
    Customer.find(params[:id]).destroy
    flash[:success] = "The account for #{@customer.customer_name} has been denied. They have been notified via email."
    redirect_to pending_customers_url
  end

  def pending_customers
    # Manager Dashboard
    @pending_users = User.where(approved: false)
    @total_users = User.all
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @job_requests = JobRequest.all
    @total_jobs = Job.all
  end

  def pending_approval
    # Customer Dashboard
    @customer = current_customer
    @pending_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ?", @customer.id, true)
    @approved_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND accepted = ?", @customer.id, false, true)
    @rejected_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND denied = ?", @customer.id, false, true)
    @expired_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND expired = ?", @customer.id, false, true)
    @total_job_requests = JobRequest.where("customer_id = ?", @customer.id)
    @current_jobs = Job.joins(:confirmed_interpreters).where("customer_id = ?", current_customer.id)
    @completed_jobs = Job.joins(:completing_interpreters).where("customer_id = ?", current_customer.id)

    @customer_jobs = Job.where("customer_id = ?", current_customer.id)
      @pending_jobs = Array.new
      @customer_jobs.each do |customer_job|
        if (!customer_job.confirmed_interpreters.any? && !customer_job.expired?)
          @pending_jobs.push customer_job
        end
      end
  end

  def approved_job_requests
    # Customer Dashboard
    @customer = current_customer
    @pending_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ?", @customer.id, true)
    @approved_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND accepted = ?", @customer.id, false, true)
    @rejected_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND denied = ?", @customer.id, false, true)
    @expired_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND expired = ?", @customer.id, false, true)
    @total_job_requests = JobRequest.where("customer_id = ?", @customer.id)
    @current_jobs = Job.joins(:confirmed_interpreters).where("customer_id = ?", current_customer.id)
    @completed_jobs = Job.joins(:completing_interpreters).where("customer_id = ?", current_customer.id)

    @customer_jobs = Job.where("customer_id = ?", current_customer.id)
      @pending_jobs = Array.new
      @customer_jobs.each do |customer_job|
        if (!customer_job.confirmed_interpreters.any? && !customer_job.expired?)
          @pending_jobs.push customer_job
        end
      end
  end

  def rejected_job_requests
    # Customer Dashboard
    @customer = current_customer
    @pending_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ?", @customer.id, true)
    @approved_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND accepted = ?", @customer.id, false, true)
    @rejected_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND denied = ?", @customer.id, false, true)
    @expired_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND expired = ?", @customer.id, false, true)
    @total_job_requests = JobRequest.where("customer_id = ?", @customer.id)
    @current_jobs = Job.joins(:confirmed_interpreters).where("customer_id = ?", current_customer.id)
    @completed_jobs = Job.joins(:completing_interpreters).where("customer_id = ?", current_customer.id)

    @customer_jobs = Job.where("customer_id = ?", current_customer.id)
      @pending_jobs = Array.new
      @customer_jobs.each do |customer_job|
        if (!customer_job.confirmed_interpreters.any? && !customer_job.expired?)
          @pending_jobs.push customer_job
        end
      end
  end

  def expired_job_requests
    # Customer Dashboard
    @customer = current_customer
    @pending_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ?", @customer.id, true)
    @approved_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND accepted = ?", @customer.id, false, true)
    @rejected_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND denied = ?", @customer.id, false, true)
    @expired_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND expired = ?", @customer.id, false, true)
    @total_job_requests = JobRequest.where("customer_id = ?", @customer.id)
    @current_jobs = Job.joins(:confirmed_interpreters).where("customer_id = ?", current_customer.id)
    @completed_jobs = Job.joins(:completing_interpreters).where("customer_id = ?", current_customer.id)

    @customer_jobs = Job.where("customer_id = ?", current_customer.id)
      @pending_jobs = Array.new
      @customer_jobs.each do |customer_job|
        if (!customer_job.confirmed_interpreters.any? && !customer_job.expired?)
          @pending_jobs.push customer_job
        end
      end
  end

  def approve_account
    @customer = Customer.find(params[:id])
    @approving_manager = current_user
    @customer.approve_customer_account
    @customer.send_account_approved_email(@approving_manager)
    flash[:success] = "#{@customer.customer_name} has been approved. They have been notified via email."
    redirect_to pending_customers_url
  end

  def deactivate_customer
    @customer = Customer.find(params[:id])
    @customer.deactivate_customer
    flash[:success] = "The account for #{@customer.customer_name} has been deactivated."
  end

  private

    def customer_params
      params.require(:customer).permit(:contact_first_name, :contact_last_name, :billing_address_line_1,
      																 :billing_address_line_2, :billing_address_line_3,
      																 :mail_address_line_1, :mail_address_line_2, :mail_address_line_3,
      																 :customer_name, :phone_number, :phone_number_extension,
      																 :contact_phone_number, :contact_phone_number_extension, :email, :fax,
                                       :password, :password_confirmation, {:job_ids => []})
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

    # Confirms a logged-in customer.
    def logged_in_customer
      unless customer_logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms either a logged-in user or customer.
    def logged_in_user_or_customer
      unless user_logged_in? || customer_logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct customer.
    def correct_customer
      @customer = Customer.find(params[:id])
      redirect_to(root_url) unless current_customer?(@customer)
    end

    # Confirms a correct customer or manager user.
    def correct_customer_or_manager_user
      @customer = Customer.find(params[:id])
      if (current_customer && current_customer?(@customer))
        # Do Nothing
      elsif (current_user && current_user.manager?)
        # Do Nothing
      else
        redirect_to(root_url)
      end
    end

    # Confirms a manager user.
    def manager_user
      redirect_to(root_url) unless current_user && current_user.manager?
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user && current_user.admin?
    end

    # Marks jobs and job requests as expired or completed based on the time.
    def update_job_and_job_request_statuses
      mark_expired_jobs
      mark_expired_job_requests
      mark_completed_jobs
    end
end