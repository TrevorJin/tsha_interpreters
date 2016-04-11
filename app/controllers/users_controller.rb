class UsersController < ApplicationController
  before_action :logged_in_user, only: [:dashboard, :show, :index, :edit, :update, :promote_to_manager,
                                        :promote_to_admin, :demote_to_manager, :demote_to_interpreter,
                                        :approve_account, :deny_account, :pending_users, :deactivate_user,
                                        :promote_qualification, :confirmed_jobs, :attempted_jobs,
                                        :rejected_jobs, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :logged_in_user_or_customer, only: [:current_jobs, :pending_jobs, :completed_jobs]
  before_action :manager_user,   only: [:dashboard, :index, :approve_account, :deny_account, :pending_users,
                                        :promote_qualification]
  before_action :admin_user,     only: [:promote_to_manager, :promote_to_admin, :demote_to_manager,
                                        :demote_to_interpreter, :deactivate_user, :destroy]
  before_action :update_job_and_job_request_statuses, only: [:current_jobs, :pending_jobs, :completed_jobs,
                                                              :index, :show, :dashboard, :pending_users,
                                                              :rejected_jobs]

  def index
    @pending_users = User.where(approved: false)
    @total_users = User.all
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @job_requests = JobRequest.all
    @total_jobs = Job.all

    @user = current_user
    @current_jobs = @user.confirmed_jobs.where(has_interpreter_assigned: true)
    @pending_jobs = @user.attempted_jobs
    @completed_jobs = @user.completed_jobs
    @rejected_jobs = @user.rejected_jobs
    
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

    @user = current_user
    @current_jobs = @user.confirmed_jobs.where(has_interpreter_assigned: true)
    @pending_jobs = @user.attempted_jobs
    @completed_jobs = @user.completed_jobs
    @rejected_jobs = @user.rejected_jobs

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
    name = "#{@user.first_name} #{@user.last_name}"
    User.find(params[:id]).destroy
    flash[:success] = "#{name}'s account has been denied."
    redirect_to pending_interpreters_url
  end

  def dashboard
    @total_users = User.all
    @pending_users = User.where(approved: false)
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @job_requests = JobRequest.all
    @total_jobs = Job.all

    @user = current_user
    @current_jobs = @user.confirmed_jobs.where(has_interpreter_assigned: true)
    @pending_jobs = @user.attempted_jobs
    @completed_jobs = @user.completed_jobs
    @rejected_jobs = @user.rejected_jobs

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

    @user = current_user
    @current_jobs = @user.confirmed_jobs.where(has_interpreter_assigned: true)
    @pending_jobs = @user.attempted_jobs
    @completed_jobs = @user.completed_jobs
    @rejected_jobs = @user.rejected_jobs
  end

  def current_jobs
    @total_users = User.all
    @pending_users = User.where(approved: false)
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @job_requests = JobRequest.all
    @total_jobs = Job.all

    if current_user
      @user = current_user
      @current_jobs = @user.confirmed_jobs.where(has_interpreter_assigned: true).order(start: :desc)
      @pending_jobs = @user.attempted_jobs
      @completed_jobs = @user.completed_jobs
      @rejected_jobs = @user.rejected_jobs
    elsif current_customer
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
  end

  def pending_jobs
    @total_users = User.all
    @pending_users = User.where(approved: false)
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @job_requests = JobRequest.all
    @total_jobs = Job.all

    if current_user
      @user = current_user
      @current_jobs = @user.confirmed_jobs.where(has_interpreter_assigned: true)
      @pending_jobs = @user.attempted_jobs
      @completed_jobs = @user.completed_jobs
      @rejected_jobs = @user.rejected_jobs
    elsif current_customer
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
  end

  def completed_jobs
    @total_users = User.all
    @pending_users = User.where(approved: false)
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @job_requests = JobRequest.all
    @total_jobs = Job.all

    if current_user
      @user = current_user
      @current_jobs = @user.confirmed_jobs.where(has_interpreter_assigned: true)
      @pending_jobs = @user.attempted_jobs
      @completed_jobs = @user.completed_jobs
      @rejected_jobs = @user.rejected_jobs
    elsif current_customer
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
  end

  def rejected_jobs
    @total_users = User.all
    @pending_users = User.where(approved: false)
    @total_customers = Customer.all
    @pending_customers = Customer.where(approved: false)
    @job_requests = JobRequest.all
    @total_jobs = Job.all
    
    @user = current_user
    @current_jobs = @user.confirmed_jobs.where(has_interpreter_assigned: true)
    @pending_jobs = @user.attempted_jobs
    @completed_jobs = @user.completed_jobs
    @rejected_jobs = @user.rejected_jobs
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

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
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

    # Marks jobs and job requests as expired or completed based on the time.
    def update_job_and_job_request_statuses
      mark_expired_jobs
      mark_expired_job_requests
      mark_completed_jobs
    end
end
