class ManagerInvoicesController < ApplicationController
  before_action :active_or_manager_user, only: [:index, :show]
  before_action :logged_in_user_or_customer, only: [:show, :index,
                                                    :new_manager_invoice_from_interpreter_invoice,
                                                    :create]
  before_action :manager_user, only: [:new_manager_invoice_from_interpreter_invoice,
                                      :create]
  before_action :manager_dashboard, only: [:index, :show,
                                           :new_manager_invoice_from_interpreter_invoice,
                                           :create]
  before_action :interpreter_dashboard, only: [:index, :show]
  before_action :customer_dashboard, only: [:index, :show]
  before_action :update_job_and_job_request_statuses, only: [:index, :show,
                                                             :new_manager_invoice_from_interpreter_invoice,
                                                             :create]

  # Show all manager invoices to manager.
  # Show relevant invoices to interpreters and customers.
  def index
    if current_user && !current_user.manager?
      @manager_invoices = current_user.manager_invoices.paginate(page: params[:page]).order(end: :desc)
    elsif (user_logged_in? && current_user.manager?) || customer_logged_in?
        # Manager Search
      if params[:search]
        @manager_invoices = ManagerInvoice.search(params[:search][:query], params[:page]).order(end: :desc)
        if params[:search][:created_after].present?
          created_after_string = params[:search][:created_after].to_s
          created_after = DateTime.strptime(created_after_string, '%m-%d-%Y %H:%M')
          @manager_invoices = @manager_invoices.where('created_at >= ?', created_after)
          if params[:search][:created_before].present?
            created_before_string = params[:search][:created_before].to_s
            created_before = DateTime.strptime(created_before_string, '%m-%d-%Y %H:%M')
            @manager_invoices = @manager_invoices.where('created_at <= ?', created_before)
          end
        elsif params[:search][:created_before].present?
          created_before_string = params[:search][:created_before].to_s
          created_before = DateTime.strptime(created_before_string, '%m-%d-%Y %H:%M')
          @manager_invoices = @manager_invoices.where('created_at <= ?', created_before)
        end
      else
        @manager_invoices = ManagerInvoice.paginate(page: params[:page]).order(end: :desc)
      end
    elsif customer_logged_in?
      @manager_invoices = []
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
        @current_job.job_status_invoices_submitted
        flash[:info] = 'All manager invoices submitted. This job is complete.'
      else
        flash[:info] = 'Manager invoice has been successfully created.'
      end

      redirect_to manager_invoices_url
    else
      render 'new_manager_invoice_from_interpreter_invoice'
    end
  end

  private

  def manager_invoice_params
    params.require(:manager_invoice).permit(:start, :end, :job_type,
                                            :event_location_address_line_1, 
                                            :event_location_address_line_2,
                                            :event_location_address_line_3,
                                            :contact_person_first_name,
                                            :contact_person_last_name,
                                            :contact_person_phone_number,
                                            :interpreter_comments, :user_id,
                                            :job_id, :interpreter_invoice_id,
                                            :miles, :mile_rate,
                                            :interpreting_hours,
                                            :interpreting_rate,
                                            :extra_miles, :extra_mile_rate,
                                            :extra_interpreting_hours,
                                            :extra_interpreting_rate)
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
  def active_or_manager_user
    if current_user && !current_user.manager? && !current_user.active?
      redirect_to(jobs_url)
    elsif current_customer && !current_customer.active?
      redirect_to(jobs_url)
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

  # Confirms a manager user.
  def manager_user
    redirect_to(root_url) unless current_user.manager?
  end
end
