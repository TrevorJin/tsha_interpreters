class ManagerInvoicesController < ApplicationController
  before_action :logged_in_user, only: [:index, :new_manager_invoice_from_interpreter_invoice]
  before_action :manager_user, only: [:index, :new_manager_invoice_from_interpreter_invoice]
  before_action :manager_dashboard, only: [:index, :new_manager_invoice_from_interpreter_invoice]

  def index
    # Manager Search
    if params[:search]
      @manager_invoices = ManagerInvoice.search(params[:search], params[:page]).order(end: :desc)
    else
      @manager_invoices = ManagerInvoice.paginate(page: params[:page]).order(end: :desc)
    end
  end

  def new_manager_invoice_from_interpreter_invoice
    @interpreter_invoice = InterpreterInvoice.find(params[:interpreter_invoice_id])
    @manager_invoice = ManagerInvoice.new
  end

  def create
    @manager_invoice = ManagerInvoice.new(manager_invoice_params)
    if @manager_invoice.save
      flash[:info] = "Manager invoice has been successfully created."
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
                                              :job_id, :miles, :mile_rate, :interpreting_hours, :interpreting_rate,
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
        @jobs_with_interpreter_assigned.each do |job|
          if Time.now < job.start
            confirmed_jobs.push job
          end
        end
        @jobs_awaiting_completion = Job.where(has_interpreter_assigned: true, completed: false).order(end: :desc)
        @jobs_awaiting_invoice = Job.where(has_interpreter_assigned: true, invoice_submitted: false, completed: true).order(end: :desc)
        @expired_jobs = Job.where(expired: true).order(end: :desc)
        @total_jobs = Job.all.order(end: :desc)
        @interpreter_invoices = InterpreterInvoice.all.order(end: :desc)
        @manager_invoices = ManagerInvoice.all.order(end: :desc)
      end
    end

    # Marks jobs and job requests as expired or completed based on the time.
    def update_job_and_job_request_statuses
      mark_expired_jobs
      mark_expired_job_requests
      mark_completed_jobs
    end
end
