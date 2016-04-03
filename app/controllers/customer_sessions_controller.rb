class CustomerSessionsController < ApplicationController
  def new
  end

  def create
  	customer = Customer.find_by(email: params[:customer_session][:email].downcase)
    if customer && customer.authenticate(params[:customer_session][:password])
      if customer.activated?
        customer_log_in customer
        params[:customer_session][:remember_me] == '1' ? customer_remember(customer) : customer_forget(customer)
        customer_redirect_back_or customer
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    customer_log_out if customer_logged_in?
  	redirect_to root_url
  end
end
