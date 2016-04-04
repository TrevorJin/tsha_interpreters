class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
    customer = Customer.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        user_log_in user
        params[:session][:remember_me] == '1' ? user_remember(user) : user_forget(user)
        redirect_back_or user
      else
        message  = "Interpreter account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    elsif customer && customer.authenticate(params[:session][:password])
      if customer.activated?
        customer_log_in customer
        params[:session][:remember_me] == '1' ? customer_remember(customer) : customer_forget(customer)
        redirect_back_or customer
      else
        message  = "Customer account not activated. "
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
    user_log_out if user_logged_in?
    customer_log_out if customer_logged_in?
  	redirect_to root_url
  end
end
