class UsersController < ApplicationController
  before_action :logged_in_user, only: [:dashboard, :show, :index, :edit, :update, :promote_to_manager,
                                        :promote_to_admin, :demote_to_manager, :demote_to_interpreter,
                                        :approve_account, :deny_account, :pending_users, :deactivate_user,
                                        :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :manager_user,   only: [:dashboard, :index, :approve_account, :deny_account, :pending_users]
  before_action :admin_user,     only: [:promote_to_manager, :promote_to_admin, :demote_to_manager,
                                        :demote_to_interpreter, :deactivate_user, :destroy]

  def index
    @pending_users = User.where(approved: false)
    @total_users = User.all
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @job_requests = JobRequest.all
    @total_jobs = Job.all
    
    if params[:search]
      @users = User.search(params[:search], params[:page]).order(admin: :desc, manager: :desc, last_name: :asc, first_name: :asc)
    else
      @users = User.paginate(page: params[:page]).order(admin: :desc, manager: :desc, last_name: :asc, first_name: :asc)
    end
  end

  def show
    @total_users = User.all
    @pending_users = User.where(approved: false)
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @job_requests = JobRequest.all
    @total_jobs = Job.all

    @user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  # The only account destruction will be for interpreters trying to have their new account accepted.
  # Any existing interpreter that should be blocked will be put into a "deactivated" state instead of
  # being destroyed for record keeping purposes. We do not want to lose their history with TSHA.
  def destroy
    @user = User.find(params[:id])
    @user.send_account_denied_email
    name = "#{@user.first_name} #{@user.last_name}"
    User.find(params[:id]).destroy
    flash[:success] = "#{name}'s account has been denied. They have been notified via email."
    redirect_to pending_interpreters_url
  end

  def dashboard
    @total_users = User.all
    @pending_users = User.where(approved: false)
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @job_requests = JobRequest.all
    @total_jobs = Job.all

    @interpreters = User.all
    @jobs = Job.all
    @job_requests = JobRequest.all
    @customers = Customer.all
  end

  def pending_users
    @total_users = User.all
    @pending_users = User.where(approved: false)
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @job_requests = JobRequest.all
    @total_jobs = Job.all
  end

  def promote_to_manager
    @user = User.find(params[:id])
    @user.change_to_manager
    flash[:success] = "#{@user.first_name} #{@user.last_name} has been promoted to a manager."
    redirect_to users_url
  end

  def promote_to_admin
    @user = User.find(params[:id])
    @user.change_to_admin
    flash[:success] = "#{@user.first_name} #{@user.last_name} has been promoted to an admin."
    redirect_to users_url
  end

  def demote_to_manager
    @user = User.find(params[:id])
    @user.change_to_manager
    flash[:success] = "#{@user.first_name} #{@user.last_name} has been demoted to a manager."
    redirect_to users_url
  end

  def demote_to_interpreter
    @user = User.find(params[:id])
    @user.change_to_interpreter
    flash[:success] = "#{@user.first_name} #{@user.last_name} has been demoted to an interpreter."
    redirect_to users_url
  end

  def approve_account
    @user = User.find(params[:id])
    @approving_manager = current_user
    @user.approve_interpreter_account
    @user.send_account_approved_email(@approving_manager)
    flash[:success] = "#{@user.first_name} #{@user.last_name} has been approved. They have been notified via email."
    redirect_to pending_interpreters_url
  end

  def deactivate_user
    @user = User.find(params[:id])
    @user.deactivate_user
    flash[:success] = "#{@user.first_name} #{@user.last_name}'s account has been deactivated."
  end

  private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :gender, :email, :cell_phone,
                                   :password, :password_confirmation)
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

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms a manager user.
    def manager_user
      redirect_to(root_url) unless current_user.manager?
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
