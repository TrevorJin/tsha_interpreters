module CustomerSessionsHelper
  # General Methods

  # Redirects to stored location (or to the default).
  def customer_redirect_back_or(default)
    redirect_to(customer_session[:forwarding_url] || default)
    customer_session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def customer_store_location
    customer_session[:forwarding_url] = request.url if request.get?
  end

  # Customer Methods

  # Logs in the given customer.
  def customer_log_in(customer)
    customer_session[:customer_id] = customer.id
  end

  # Remembers a customer in a persistent customer session.
  def customer_remember(customer)
    customer.remember
    cookies.permanent.signed[:customer_id] = customer.id
    cookies.permanent[:remember_token] = customer.remember_token
  end

  # Returns true if the given customer is the current customer.
  def current_customer?(customer)
    customer == current_customer
  end

  # Returns the current logged-in customer (if any).
  def current_customer
    if (customer_id = customer_session[:customer_id])
      @current_customer ||= Customer.find_by(id: customer_id)
    elsif (customer_id = cookies.signed[:customer_id])
      customer = Customer.find_by(id: customer_id)
      if customer && customer.authenticated?(:remember, cookies[:remember_token])
        customer_log_in customer
        @current_customer = customer
      end
    end
  end

  # Returns true if the customer is logged in, false otherwise.
  def customer_logged_in?
    !current_customer.nil?
  end

  # Forgets a persistent customer session.
  def customer_forget(customer)
    customer.forget
    cookies.delete(:customer_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current customer.
  def customer_log_out
    customer_forget(current_customer)
    customer_session.delete(:customer_id)
    @current_customer = nil
  end
end
