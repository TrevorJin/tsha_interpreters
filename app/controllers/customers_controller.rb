class CustomersController < ApplicationController

  def index
    @customers = Customer.all
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      flash[:info] = "Customer has been successfully created."
      redirect_to customers_url
    else
      render 'new'
    end
  end

  private

    def customer_params
      params.require(:customer).permit(:contact_first_name, :contact_last_name, :billing_address_line_1,
      																 :billing_address_line_2, :billing_address_line_3,
      																 :mail_address_line_1, :mail_address_line_2, :mail_address_line_3,
      																 :customer_name, :phone_number, :phone_number_extension,
      																 :contact_phone_number, :contact_phone_number_extension, :email, :fax,
      																 {:job_ids => []})
    end
end