module SessionsHelper
  # General Methods

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

	# User Methods

  # Logs in the given user.
  def user_log_in(user)
    session[:user_id] = user.id
  end

  # Logs in the given customer.
  def customer_log_in(customer)
    session[:customer_id] = customer.id
  end

  # Remembers a user in a persistent session.
  def user_remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Remembers a customer in a persistent session.
  def customer_remember(customer)
    customer.remember
    cookies.permanent.signed[:customer_id] = customer.id
    cookies.permanent[:remember_token] = customer.remember_token
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  # Returns true if the given customer is the current customer.
  def current_customer?(customer)
    customer == current_customer
  end

  # Returns the current logged-in user (if any).
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        user_log_in user
        @current_user = user
      end
    end
  end

  # Returns the current logged-in customer (if any).
  def current_customer
    if (customer_id = session[:customer_id])
      @current_customer ||= Customer.find_by(id: customer_id)
    elsif (customer_id = cookies.signed[:customer_id])
      customer = Customer.find_by(id: customer_id)
      if customer && customer.authenticated?(:remember, cookies[:remember_token])
        customer_log_in customer
        @current_customer = customer
      end
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def user_logged_in?
    !current_user.nil?
  end

  # Returns true if the customer is logged in, false otherwise.
  def customer_logged_in?
    !current_customer.nil?
  end

  # Forgets a persistent session for a user.
  def user_forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Forgets a persistent session for a customer.
  def customer_forget(customer)
    customer.forget
    cookies.delete(:customer_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def user_log_out
    user_forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Logs out the current customer.
  def customer_log_out
    customer_forget(current_customer)
    session.delete(:customer_id)
    @current_customer = nil
  end

  # Dashboards

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

  # Provides a customer dashboard for a customer.
  def customer_dashboard
    if current_customer
      @pending_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ?", current_customer.id, true)
      @approved_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND accepted = ?", current_customer.id, false, true)
      @rejected_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND denied = ?", current_customer.id, false, true)
      @expired_job_requests = JobRequest.where("customer_id = ? AND awaiting_approval = ? AND expired = ?", current_customer.id, false, true)
      @total_job_requests = JobRequest.where("customer_id = ?", current_customer.id)
      @customer = current_customer
      @current_jobs = Job.joins(:confirmed_interpreters).where("customer_id = ? AND  completed = ?", current_customer.id, false)
      @completed_jobs = Job.joins(:completing_interpreters).where("customer_id = ? AND completed = ?", current_customer.id, true)

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
end
