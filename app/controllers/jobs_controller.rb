class JobsController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :manager_user,   only: [:index, :edit, :update, :destroy]

  def index
    @jobs = Job.all
  end

  def show
    @job = Job.find(params[:id])
  end

  def new
  	@job = Job.new
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      flash[:info] = "Job has been successfully created."
      redirect_to jobs_url
    else
      render 'new'
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])
    if @job.update_attributes(job_params)
      flash[:success] = "Job updated"
      redirect_to @job
    else
      render 'edit'
    end
  end

  def destroy
    Job.find(params[:id]).destroy
    flash[:success] = "Job deleted"
    redirect_to jobs_url
  end

  private

    def job_params
      params.require(:job).permit(:start, :end, :address_line_1, :address_line_2,
                                   :address_line_3, :city, :state, :zip, :invoice_notes,
                                   :notes_for_irp, :notes_for_interpreter, :directions)
    end

    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms a manager user.
    def manager_user
      redirect_to(root_url) unless current_user.manager?
    end
end
