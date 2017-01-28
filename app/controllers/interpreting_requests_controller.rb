class InterpretingRequestsController < ApplicationController
  before_action :logged_in_user

  def create
    job = Job.find(params[:job_id])
    current_user.request_job(job)
    flash[:success] = 'Your job request has been submitted.'
    redirect_to jobs_url
  end

  def destroy; end

  private

  # Before filters

  # Confirms a logged-in user.
  def logged_in_user
    unless user_logged_in?
      store_location
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end
end
