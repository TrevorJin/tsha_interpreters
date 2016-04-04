class CustomersController < ApplicationController
  before_action :logged_in_user, only: [:index, :pending_customers, :destroy]
  before_action :manager_user,   only: [:index, :pending_customers]
  before_action :admin_user, only: [:destroy]
  before_action :logged_in_user_or_customer, only: [:edit, :update]
  before_action :correct_customer_or_manager_user, only: [:edit, :update]

  def index
    @pending_users = User.where(approved: false)
    @total_users = User.all
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)

    if params[:search]
      @customers = Customer.search(params[:search], params[:page]).order(customer_name: :asc)
    else
      @customers = Customer.paginate(page: params[:page]).order(customer_name: :asc)
    end
  end

  def show
    @pending_users = User.where(approved: false)
    @total_users = User.all
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)

    @customer = Customer.find(params[:id])
  end

  def new
    @pending_users = User.where(approved: false)
    @total_users = User.all
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)

    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      @customer.send_activation_email
      flash[:info] = "An email has been sent to activate this account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @total_users = User.all
    @pending_users = User.where(approved: false)
    
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
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @total_users = User.all
    @pending_users = User.where(approved: false)
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

    # Confirms either a logged-in user or customer.
    def logged_in_user_or_customer
      unless user_logged_in? || customer_logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
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
end