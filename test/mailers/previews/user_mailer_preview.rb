# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
		user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_approved
  def account_approved
    manager = User.first
    user = User.find(20)
    UserMailer.account_approved(user, manager)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_denied
  def account_denied
    user = User.find(20)
    UserMailer.account_denied(user)
  end
end
