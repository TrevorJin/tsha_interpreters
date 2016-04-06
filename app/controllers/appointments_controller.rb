class AppointmentsController < ApplicationController
  before_action :logged_in_user

  def create
  	job = Job.find(params[:job_id])
  	interpreter = User.find(params[:attempted_interpreter_id])
    interpreter.confirm_job(job)
    flash[:success] = "#{interpreter.first_name} #{interpreter.last_name} has been assigned to this job."
    redirect_to jobs_url
  end

  def destroy
  end

  private

    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless user_logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
