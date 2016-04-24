class ManagerInvoicesController < ApplicationController
  before_action :active_or_manager_user, only: [:index, :show]
  before_action :logged_in_user_or_customer, only: [:show, :index, :new_manager_invoice_from_interpreter_invoice, :create]
  before_action :manager_user, only: [:new_manager_invoice_from_interpreter_invoice, :create]
  before_action :manager_dashboard, only: [:index, :show, :new_manager_invoice_from_interpreter_invoice,
                                           :create]
  before_action :interpreter_dashboard, only: [:index, :show]
  before_action :customer_dashboard, only: [:index, :show]
  before_action :update_job_and_job_request_statuses, only: [:index, :show,
                                                             :new_manager_invoice_from_interpreter_invoice,
                                                             :create]

  def index
    if current_user && !current_user.manager?
      @manager_invoices = current_user.manager_invoices.paginate(page: params[:page]).order(end: :desc)
    elsif user_logged_in? && current_user.manager?
      # Manager Search
      if params[:search]
        @manager_invoices = ManagerInvoice.search(params[:search], params[:page]).order(end: :desc)
      else
        @manager_invoices = ManagerInvoice.paginate(page: params[:page]).order(end: :desc)
      end
    elsif customer_logged_in?
      @manager_invoices = Array.new
      @customer_jobs = current_customer.jobs
      @customer_jobs.each do |customer_job|
        customer_job.manager_invoices.each do |manager_invoice|
          @manager_invoices.push manager_invoice
        end
      end
      # @manager_invoices = @manager_invoices.paginate(page: params[:page]).order(end: :desc)
    end
  end

  def show
    @manager_invoice = ManagerInvoice.find(params[:id])
  end

  def new_manager_invoice_from_interpreter_invoice
    @interpreter_invoice = InterpreterInvoice.find(params[:interpreter_invoice_id])
    @manager_invoice = ManagerInvoice.new
  end

  def create
    @manager_invoice = ManagerInvoice.new(manager_invoice_params)
    if @manager_invoice.save
      
      @current_job = Job.find(manager_invoice_params[:job_id])
      @confirmed_interpreters_number = @current_job.confirmed_interpreters.count
      @manager_invoices_number = @current_job.manager_invoices.count

      if (@confirmed_interpreters_number == @manager_invoices_number)
        @current_job.job_invoices_submitted
        flash[:info] = "All manager invoices submitted. This job is complete."
      else
        flash[:info] = "Manager invoice has been successfully created."
      end

      redirect_to manager_invoices_url
    else
      render 'new_manager_invoice_from_interpreter_invoice'
    end
  end

  private

    def manager_invoice_params
      params.require(:manager_invoice).permit(:start, :end, :job_type, :event_location_address_line_1, 
                                              :event_location_address_line_2, :event_location_address_line_3,
                                              :contact_person_first_name, :contact_person_last_name,
                                              :contact_person_phone_number, :interpreter_comments, :user_id,
                                              :job_id, :interpreter_invoice_id,
                                              :miles, :mile_rate, :interpreting_hours, :interpreting_rate,
                                              :extra_miles, :extra_mile_rate, :extra_interpreting_hours,
                                              :extra_interpreting_rate)
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

    # Provides an interpreter dashboard for a regular user.
    def interpreter_dashboard
      if current_user && !current_user.manager?
        @user = current_user
        @user_jobs = @user.eligible_jobs
        @current_jobs = @user.confirmed_jobs.where(has_interpreter_assigned: true, completed: false).order(end: :desc)
        @pending_jobs = @user.attempted_jobs.order(end: :desc)
        @completed_jobs = @user.completed_jobs.order(end: :desc)
        @rejected_jobs = @user.rejected_jobs.order(end: :desc)
        @interpreter_invoices = @user.interpreter_invoices.order(end: :desc)
        @manager_invoices = @user.manager_invoices.order(end: :desc)
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
