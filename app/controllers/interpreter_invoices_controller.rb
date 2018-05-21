class InterpreterInvoicesController < ApplicationController
  before_action :logged_in_user,
    only: [:index, :show, :new_interpreter_invoice_from_job, :create]
  before_action :active_user_or_manager_user,
    only: [:index, :show, :new_interpreter_invoice_from_job, :create]
  before_action :manager_dashboard, only: [:index, :show]
  before_action :interpreter_dashboard,
    only: [:index, :show, :new_interpreter_invoice_from_job, :create]
  before_action :update_job_and_job_request_statuses,
    only: [:index, :show, :new_interpreter_invoice_from_job, :create]

  # Show all interpreter invoices to manager.
  # Show active invoices to regular user.
  def index
    if current_user && !current_user.manager?
      @user_invoices = current_user.interpreter_invoices.where(job_completed: false).order(start_date: :desc)
    elsif current_user && current_user.manager?
      # Manager Search
      if params[:search]
        manager_search
      else
        @user_invoices = InterpreterInvoice.paginate(page: params[:page]).order(start_date: :desc)
      end
    end
  end

  def show
    @interpreter_invoice = InterpreterInvoice.find(params[:id])
  end

  def new_interpreter_invoice_from_job
    @job = Job.find(params[:job_id])
    @interpreter_invoice = InterpreterInvoice.new
  end

  def create
    @interpreter_invoice = InterpreterInvoice.new(interpreter_invoice_params)
    if @interpreter_invoice.save
      flash[:info] = 'Invoice has been successfully submitted.'
      redirect_to current_jobs_url
    else
      render 'new_interpreter_invoice_from_job'
    end
  end

  private

  def interpreter_invoice_params
    params.require(:interpreter_invoice).permit(:start_date, :start_time,
                                                :requested_end_time,
                                                :actual_end_time, :job_type,
                                                :event_location_address_line_1, 
                                                :event_location_address_line_2,
                                                :event_location_address_line_3,
                                                :contact_person_first_name,
                                                :contact_person_last_name,
                                                :contact_person_phone_number,
                                                :interpreter_comments, :user_id,
                                                :job_id, :miles, :mile_rate,
                                                :interpreting_hours,
                                                :interpreting_rate,
                                                :extra_interpreting_hours,
                                                :extra_interpreting_rate,
                                                :misc_travel, :legal_hours,
                                                :legal_rate, :extra_legal_hours,
                                                :extra_legal_rate)
  end

  def manager_search
    @user_invoices = InterpreterInvoice.search(params[:search][:query], params[:page]).order(start_date: :desc)
    if params[:search][:created_after].present?
      created_after_string = params[:search][:created_after].to_s
      created_after = DateTime.strptime(created_after_string, '%m-%d-%Y %H:%M')
      @user_invoices = @user_invoices.where('created_at >= ?', created_after)
      if params[:search][:created_before].present?
        created_before_string = params[:search][:created_before].to_s
        created_before = DateTime.strptime(created_before_string, '%m-%d-%Y %H:%M')
        @user_invoices = @user_invoices.where('created_at <= ?', created_before)
      end
    elsif params[:search][:created_before].present?
      created_before_string = params[:search][:created_before].to_s
      created_before = DateTime.strptime(created_before_string, '%m-%d-%Y %H:%M')
      @user_invoices = @user_invoices.where('created_at <= ?', created_before)
    end
  end

  # Before filters

  # Confirms a logged-in user.
  def logged_in_user
    unless user_logged_in?
      store_location
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end

  # Confirms the user is activated if not a manager user.
  def active_user_or_manager_user
    if current_user && !current_user.manager? && !current_user.active?
      redirect_to(jobs_url)
    end
  end
end
