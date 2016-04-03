class CustomerAccountActivationsController < ApplicationController
	def edit
    customer = Customer.find_by(email: params[:email])
    if customer && !customer.activated? && customer.authenticated?(:activation, params[:id])
      customer.activate
      customer_log_in customer
      flash[:success] = "Account activated!"
      redirect_to customer
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
