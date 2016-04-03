# Preview all emails at http://localhost:3000/rails/mailers/customer_mailer
class CustomerMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/customer_mailer/account_activation
  def account_activation
    customer = Customer.first
    customer.activation_token = Customer.new_token
    CustomerMailer.account_activation(customer)
  end

  # Preview this email at http://localhost:3000/rails/mailers/customer_mailer/password_reset
  def password_reset
    customer = Customer.first
    customer.reset_token = Customer.new_token
    CustomerMailer.password_reset(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/customer_mailer/account_approved
  def account_approved
    manager = User.first
    customer = Customer.find(20)
    CustomerMailer.account_approved(customer, manager)
  end

  # Preview this email at http://localhost:3000/rails/mailers/customer_mailer/account_denied
  def account_denied
    customer = Customer.find(20)
    CustomerMailer.account_denied(customer)
  end
end
