class CustomersController < ApplicationController
  before_action :logged_in_user, only: [:index, :pending_customers, :destroy, :approve_account, :deactivate_customer,
                                        :reactivate_customer]
  before_action :logged_in_customer, only: [:pending_approval, :approved_job_requests, :rejected_job_requests,
                                            :expired_job_requests]
  before_action :logged_in_user_or_customer, only: [:show, :edit, :update]
  before_action :active_customer, only: [:pending_approval, :approved_job_requests, :rejected_job_requests,
                                         :expired_job_requests]
  before_action :manager_user,   only: [:index, :pending_customers, :approve_account]
  before_action :admin_user, only: [:destroy, :deactivate_customer, :reactivate_customer]
  before_action :correct_customer_or_manager_user, only: [:show, :edit, :update]
  before_action :manager_dashboard, only: [:index, :show, :new, :create, :edit, :update, :pending_customers]
  before_action :customer_dashboard, only: [:show, :edit, :update, :pending_approval, :approved_job_requests,
                                            :rejected_job_requests, :expired_job_requests]
  before_action :update_job_and_job_request_statuses, only: [:pending_approval, :approved_job_requests,
                                                              :rejected_job_requests, :expired_job_requests,
                                                              :index, :show, :new, :pending_customers,
                                                              :pending_approval, :approved_job_requests,
                                                              :rejected_job_requests, :expired_job_requests]

  def index
    # Manager Search
    if params[:search]
      @customers = Customer.search(params[:search], params[:page]).order(customer_name: :asc)
    else
      @customers = Customer.paginate(page: params[:page]).order(customer_name: :asc)
    end
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def new
    @customer = Customer.new
  end

  def create
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
    if params[:search]
      @pending_customers = Customer.search(params[:search], params[:page]).order(customer_name: :asc).where(approved: false)
    else
      @pending_customers = Customer.paginate(page: params[:page]).order(customer_name: :asc).where(approved: false)
    end
  end

  def pending_approval
    
  end

  def approved_job_requests
    
  end

  def rejected_job_requests
    
  end

  def expired_job_requests
    
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
    redirect_to customer_url(@customer)
  end

  def reactivate_customer
    @customer = Customer.find(params[:id])
    @customer.reactivate_customer
    flash[:success] = "The account for #{@customer.customer_name} has been reactivated."
    redirect_to customer_url(@customer)
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

    # Confirms the user is activated if not a manager user.
    def active_or_manager_user
      if (current_user && !current_user.manager? && !current_user.active?)
        redirect_to(jobs_url)
      elsif (current_customer && !current_customer.active?)
        redirect_to(jobs_url)
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

    # Confirms the user is activated if not a manager user.
    def active_customer
      if (current_customer && !current_customer.active?)
        redirect_to(job_requests_url)
      end
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
        @manager_invoices = Array.new
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