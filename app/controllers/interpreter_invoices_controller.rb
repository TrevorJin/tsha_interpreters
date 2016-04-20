class InterpreterInvoicesController < ApplicationController
  before_action :logged_in_user, only: [:index, :show]

  def index
    
  end

  def show
    # Manager Dashboard
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
    end

    # Interpreter Dashboard
    if current_user && !current_user.manager?
      @user = current_user
      @user_jobs = @user.eligible_jobs
      @current_jobs = @user.confirmed_jobs.where(has_interpreter_assigned: true)
      @pending_jobs = @user.attempted_jobs
      @completed_jobs = @user.completed_jobs
      @rejected_jobs = @user.rejected_jobs
    end

    @interpreter_invoice = InterpreterInvoice.find(params[:id])
  end

  def new
    # Interpreter Dashboard
    if current_user && !current_user.manager?
      @user = current_user
      @user_jobs = @user.eligible_jobs
      @current_jobs = @user.confirmed_jobs.where(has_interpreter_assigned: true)
      @pending_jobs = @user.attempted_jobs
      @completed_jobs = @user.completed_jobs
      @rejected_jobs = @user.rejected_jobs
    end

    @interpreter_invoice = InterpreterInvoice.new
  end

  def new_interpreter_invoice_from_job
    # Interpreter Dashboard
    if current_user && !current_user.manager?
      @user = current_user
      @user_jobs = @user.eligible_jobs
      @current_jobs = @user.confirmed_jobs.where(has_interpreter_assigned: true)
      @pending_jobs = @user.attempted_jobs
      @completed_jobs = @user.completed_jobs
      @rejected_jobs = @user.rejected_jobs
    end

    @job = Job.find(params[:job_id])
    @interpreter_invoice = InterpreterInvoice.new
  end

  def create
    # Interpreter Dashboard
    if current_user && !current_user.manager?
      @user = current_user
      @user_jobs = @user.eligible_jobs
      @current_jobs = @user.confirmed_jobs.where(has_interpreter_assigned: true)
      @pending_jobs = @user.attempted_jobs
      @completed_jobs = @user.completed_jobs
      @rejected_jobs = @user.rejected_jobs
    end
    @interpreter_invoice = InterpreterInvoice.new(interpreter_invoice_params)
    if @interpreter_invoice.save
      flash[:info] = "Invoice has been successfully submitted."
      redirect_to current_jobs_url
    else
      render 'new_interpreter_invoice_from_job'
    end
  end

  private

    def interpreter_invoice_params
      params.require(:interpreter_invoice).permit(:start, :end, :job_type, :event_location_address_line_1, 
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

    # Marks jobs and job requests as expired or completed based on the time.
    def update_job_and_job_request_statuses
      mark_expired_jobs
      mark_expired_job_requests
      mark_completed_jobs
    end
end
