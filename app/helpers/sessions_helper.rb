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
end
