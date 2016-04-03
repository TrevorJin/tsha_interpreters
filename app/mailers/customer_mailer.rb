class CustomerMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.customer_mailer.account_activation.subject
  #
  def account_activation(customer)
    @customer = customer
    mail to: customer.email, subject: "Account activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.customer_mailer.password_reset.subject
  #
  def password_reset(customer)
    @customer = customer
    mail to: customer.email, subject: "Password reset"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.customer_mailer.account_approved.subject
  #
  def account_approved(approved_customer, approving_manager)
    @customer = approved_customer
    @manager = approving_manager
    mail to: @customer.email, subject: "You have been approved as a customer with TSHA"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.customer_mailer.account_denied.subject
  #
  def account_denied(customer)
    @customer = customer
    mail to: @customer.email, subject: "Your account has not been approved by TSHA"
  end
end
