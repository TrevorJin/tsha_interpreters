class CustomersController < ApplicationController
  before_action :logged_in_user,
    only: [:index, :pending_customers, :destroy, :approve_account, :deactivate_customer,
           :reactivate_customer, :change_tsha_number, :change_fund_number,
           :change_customer_notes]
  before_action :logged_in_customer,
    only: [:pending_approval, :approved_job_requests, :rejected_job_requests,
           :expired_job_requests]
  before_action :logged_in_user_or_customer, only: [:show, :edit, :update]
  before_action :active_customer,
    only: [:pending_approval, :approved_job_requests, :rejected_job_requests,
           :expired_job_requests]
  before_action :manager_user,
    only: [:index, :pending_customers, :approve_account, :change_tsha_number,
           :change_fund_number, :change_customer_notes]
  before_action :admin_user, only: [:destroy, :deactivate_customer, :reactivate_customer]
  before_action :correct_customer_or_manager_user, only: [:show, :edit, :update]
  before_action :manager_dashboard,
    only: [:index, :show, :new, :create, :edit, :update, :pending_customers]
  before_action :customer_dashboard,
    only: [:show, :edit, :update, :pending_approval, :approved_job_requests,
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

    if @customer.approved? && user_logged_in? && current_user.manager?
      @jobs = @customer.jobs.order(start_date: :desc)
    end
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      @customer.send_activation_email
      flash[:info] = 'An email has been sent to activate this account.'
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
      flash[:success] = 'Profile updated'
      redirect_to @customer
    else
      render 'edit'
    end
  end

  # The only account destruction will be for customers trying to have their new
  # account accepted. Any existing customer that should be blocked will be put
  # into a "deactivated" state instead of being destroyed for record keeping
  # purposes. We do not want to lose their history with TSHA.
  def destroy
    @customer = Customer.find(params[:id])
    @customer.send_account_denied_email
    Customer.find(params[:id]).destroy
    flash[:success] = "The account for #{@customer.customer_name} has been denied. They have been notified via email."
    redirect_to pending_customers_url
  end

  def pending_customers
    # Manager Search
    if params[:search]
      @pending_customers = Customer.search(params[:search][:query], params[:page]).order(customer_name: :asc).where(approved: false)
      if params[:search][:account_requested_after].present?
        account_requested_after_string = params[:search][:account_requested_after].to_s
        account_requested_after = DateTime.strptime(account_requested_after_string, '%m-%d-%Y %H:%M')
        @pending_customers = @pending_customers.where('created_at >= ?', account_requested_after)
        if params[:search][:account_requested_before].present?
          account_requested_before_string = params[:search][:account_requested_before].to_s
          account_requested_before = DateTime.strptime(account_requested_before_string, '%m-%d-%Y %H:%M')
          @pending_customers = @pending_customers.where('created_at <= ?', account_requested_before)
        end
      elsif params[:search][:account_requested_before].present?
        account_requested_before_string = params[:search][:account_requested_before].to_s
        account_requested_before = DateTime.strptime(account_requested_before_string, '%m-%d-%Y %H:%M')
        @pending_customers = @pending_customers.where('created_at <= ?', account_requested_before)
      end
    else
      @pending_customers = Customer.paginate(page: params[:page]).order(customer_name: :asc).where(approved: false)
    end
  end

  def pending_approval; end

  def approved_job_requests; end

  def rejected_job_requests; end

  def expired_job_requests; end

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

  def change_tsha_number
    @customer = Customer.find(params[:id])
    @tsha_number = params[:customer][:tsha_number]
    @customer.update_attribute(:tsha_number, @tsha_number)
    flash[:success] = "#{@customer.customer_name}'s TSHA number has been updated to #{@tsha_number}."
    redirect_to customer_url(@customer)
  end

  def change_fund_number
    @customer = Customer.find(params[:id])
    @fund_number = params[:customer][:fund_number]
    @customer.update_attribute(:fund_number, @fund_number)
    flash[:success] = "#{@customer.customer_name}'s fund number has been updated to #{@fund_number}."
    redirect_to customer_url(@customer)
  end

  def change_customer_notes
    @customer = Customer.find(params[:id])
    @customer_notes = params[:customer][:customer_notes]
    @customer.update_attribute(:customer_notes, @customer_notes)
    flash[:success] = "#{@customer.customer_name}'s notes have been updated."
    redirect_to customer_url(@customer)
  end

  private

  def customer_params
    params.require(:customer).permit(:contact_first_name, :contact_last_name,
                                     :billing_address_line_1,
                                     :billing_address_line_2,
                                     :billing_address_line_3,
                                     :mail_address_line_1,
                                     :mail_address_line_2,
                                     :mail_address_line_3,
                                     :customer_name, :phone_number,
                                     :phone_number_extension,
                                     :contact_phone_number,
                                     :contact_phone_number_extension, :email,
                                     :fax, :password, :password_confirmation,
                                     { :job_ids => [] })
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
      flash[:danger] = 'Please log in.'
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
    if current_customer && current_customer?(@customer)
      # Do Nothing
    elsif current_user && current_user.manager?
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
end
