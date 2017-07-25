class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :dashboard, :edit, :update, :promote_to_manager,
                                        :promote_to_admin, :demote_to_manager, :demote_to_interpreter,
                                        :approve_account, :pending_users, :deactivate_user,
                                        :reactivate_user, :promote_qualification, :revoke_qualification,
                                        :approve_job_request, :reject_job_request, :confirmed_jobs,
                                        :attempted_jobs, :rejected_jobs, :destroy]
  before_action :active_or_manager_user, only: [:confirmed_jobs, :attempted_jobs, :rejected_jobs, :current_jobs,
                                                :pending_jobs, :completed_jobs]
  before_action :correct_user,   only: [:edit, :update]
  before_action :correct_user_or_manager_user, only: [:show]
  before_action :logged_in_user_or_customer, only: [:current_jobs, :pending_jobs, :completed_jobs]
  before_action :manager_user,   only: [:dashboard, :index, :approve_account, :pending_users,
                                        :promote_qualification, :revoke_qualification, :approve_job_request,
                                        :reject_job_request]
  before_action :admin_user,     only: [:promote_to_manager, :promote_to_admin, :demote_to_manager,
                                        :demote_to_interpreter, :deactivate_user, :reactivate_user, :destroy]
  before_action :manager_dashboard, only: [:index, :show, :new, :dashboard, :pending_users, :current_jobs, :pending_jobs,
                                           :completed_jobs, :rejected_jobs]
  before_action :interpreter_dashboard, only: [:show, :current_jobs, :pending_jobs, :completed_jobs, :rejected_jobs]
  before_action :customer_dashboard, only: [:current_jobs, :pending_jobs, :completed_jobs]
  before_action :update_job_and_job_request_statuses, only: [:index, :show, :new, :edit, :update, :dashboard,
                                                             :pending_users, :current_jobs, :pending_jobs,
                                                             :completed_jobs, :rejected_jobs, :confirmed_jobs,
                                                             :attempted_jobs]

  def index
    # Manager Search
    if params[:search]
      @users = User.search(params[:search][:query], params[:page]).order(admin: :desc, manager: :desc, last_name: :asc, first_name: :asc)
      if params[:search][:joined_after].present?
        joined_after_string = params[:search][:joined_after].to_s
        joined_after = DateTime.strptime(joined_after_string, '%m-%d-%Y %H:%M')
        @users = @users.where("created_at >= ?", joined_after)
        if params[:search][:joined_before].present?
          joined_before_string = params[:search][:joined_before].to_s
          joined_before = DateTime.strptime(joined_before_string, '%m-%d-%Y %H:%M')
          @users = @users.where("created_at <= ?", joined_before)
        end
      elsif params[:search][:joined_before].present?
        joined_before_string = params[:search][:joined_before].to_s
        joined_before = DateTime.strptime(joined_before_string, '%m-%d-%Y %H:%M')
        @users = @users.where("created_at <= ?", joined_before)
      end
    else
      @users = User.paginate(page: params[:page]).order(admin: :desc, manager: :desc, last_name: :asc, first_name: :asc)
    end
  end

  def show
    @user = User.find(params[:id])
    
    # Manager View
    if (!current_user?(@user))    
      @user_jobs = @user.eligible_jobs
      @current_jobs = @user.confirmed_jobs.where(has_interpreter_assigned: true, completed: false).order(end: :desc)
      @pending_jobs = @user.attempted_jobs.order(end: :desc)
      @completed_jobs = @user.completed_jobs.order(end: :desc)
      @rejected_jobs = @user.rejected_jobs.order(end: :desc)
      @interpreter_invoices = @user.interpreter_invoices.order(end: :desc)
      @manager_invoices = @user.manager_invoices.order(end: :desc)
    end
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
    name = "#{@user.first_name} #{@user.last_name}"
    User.find(params[:id]).destroy
    flash[:success] = "#{name}'s account has been denied."
    redirect_to pending_interpreters_url
  end

  def dashboard
    @interpreters = User.all
    @jobs = Job.all
    @job_requests = JobRequest.all
    @customers = Customer.all
  end

  def pending_users
    # Manager Search
    if params[:search]
      @pending_users = User.search(params[:search][:query], params[:page]).order(admin: :desc, manager: :desc, last_name: :asc, first_name: :asc).where(approved: false)
      if params[:search][:account_requested_after].present?
        account_requested_after_string = params[:search][:account_requested_after].to_s
        account_requested_after = DateTime.strptime(account_requested_after_string, '%m-%d-%Y %H:%M')
        @pending_users = @pending_users.where("created_at >= ?", account_requested_after)
        if params[:search][:account_requested_before].present?
          account_requested_before_string = params[:search][:account_requested_before].to_s
          account_requested_before = DateTime.strptime(account_requested_before_string, '%m-%d-%Y %H:%M')
          @pending_users = @pending_users.where("created_at <= ?", account_requested_before)
        end
      elsif params[:search][:account_requested_before].present?
        account_requested_before_string = params[:search][:account_requested_before].to_s
        account_requested_before = DateTime.strptime(account_requested_before_string, '%m-%d-%Y %H:%M')
        @pending_users = @pending_users.where("created_at <= ?", account_requested_before)
      end
    else
      @pending_users = User.paginate(page: params[:page]).order(admin: :desc, manager: :desc, last_name: :asc, first_name: :asc).where(approved: false)
    end
  end

  def current_jobs

  end

  def pending_jobs

  end

  def completed_jobs
    
  end

  def rejected_jobs
    
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
    redirect_to user_url(@user)
  end

  def reactivate_user
    @user = User.find(params[:id])
    @user.reactivate_user
    flash[:success] = "#{@user.first_name} #{@user.last_name}'s account has been reactivated."
    redirect_to user_url(@user)
  end

  def promote_to_manager
    @user = User.find(params[:id])
    @user.change_to_manager
    flash[:success] = "#{@user.first_name} #{@user.last_name} has been promoted to a manager."
    redirect_to user_url(@user)
  end

  def promote_to_admin
    @user = User.find(params[:id])
    @user.change_to_admin
    flash[:success] = "#{@user.first_name} #{@user.last_name} has been promoted to an admin."
    redirect_to user_url(@user)
  end

  def demote_to_manager
    @user = User.find(params[:id])
    @user.change_to_manager
    flash[:success] = "#{@user.first_name} #{@user.last_name} has been demoted to a manager."
    redirect_to user_url(@user)
  end

  def demote_to_interpreter
    @user = User.find(params[:id])
    @user.change_to_interpreter
    flash[:success] = "#{@user.first_name} #{@user.last_name} has been demoted to an interpreter."
    redirect_to user_url(@user)
  end

  def promote_qualification
    @user = User.find(params[:id])
    qualification = params[:qualification]
    @user.promote_qualification(qualification)
    flash[:success] = "#{@user.first_name} #{@user.last_name} has received the #{qualification} qualification."
    redirect_to user_url(@user)
  end

  def revoke_qualification
    @user = User.find(params[:id])
    qualification = params[:qualification]
    @user.revoke_qualification(qualification)
    flash[:success] = "#{@user.first_name} #{@user.last_name} no longer has the #{qualification} qualification."
    redirect_to user_url(@user)
  end

  def approve_job_request
    @job_request = JobRequest.find(params[:job_request_id])
    @job_request.approve_job_request
    flash[:success] = "Job Request #{@job_request.id} for #{@job_request.requester_first_name} #{@job_request.requester_last_name} has been marked as approved."
    redirect_to job_request_url(@job_request)
  end

  def reject_job_request
    @job_request = JobRequest.find(params[:job_request_id])
    @job_request.reject_job_request
    flash[:success] = "Job Request #{@job_request.id} for #{@job_request.requester_first_name} #{@job_request.requester_last_name} has been marked as denied."
    redirect_to job_request_url(@job_request)
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

    # Confirms the user is activated if not a manager user.
    def active_or_manager_user
      if (current_user && !current_user.manager? && !current_user.active?)
        redirect_to(jobs_url)
      elsif (current_customer && !current_customer.active?)
        redirect_to(jobs_url)
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms a correct user or manager user.
    def correct_user_or_manager_user
      @user = User.find(params[:id])
      if (current_user && current_user?(@user))
        # Do Nothing
      elsif (current_user && current_user.manager?)
        # Do Nothing
      else
        redirect_to(root_url)
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

    # Confirms a manager user.
    def manager_user
      redirect_to(root_url) unless current_user.manager?
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
