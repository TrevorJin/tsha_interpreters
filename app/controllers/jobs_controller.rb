class JobsController < ApplicationController
  before_action :logged_in_user,
    only: [:index, :new, :create, :new_job_from_job_request, :edit, :update,
           :add_interpreter_to_job, :remove_interpreter_from_job,
           :finalize_job_and_interpreters, :expire_job,
           :jobs_in_need_of_confirmed_interpreter, :jobs_awaiting_invoice,
           :processed_jobs, :expired_jobs]
  before_action :manager_user,
    only: [:new, :create, :new_job_from_job_request, :edit, :update,
           :add_interpreter_to_job, :remove_interpreter_from_job,
           :finalize_job_and_interpreters, :expire_job,
           :jobs_in_need_of_confirmed_interpreter, :jobs_awaiting_invoice,
           :processed_jobs, :expired_jobs]
  before_action :manager_correct_customer_or_interpreter, only: [:show]
  before_action :manager_dashboard,
    only: [:index, :show, :new, :new_job_from_job_request, :create, :edit,
           :jobs_in_need_of_confirmed_interpreter, :jobs_awaiting_invoice,
           :processed_jobs, :expired_jobs]
  before_action :interpreter_dashboard, only: [:index, :show]
  before_action :customer_dashboard, only: [:show]
  
  def index
    # Manager Search
    if params[:search]
      job_search
    else
      @jobs = Job.paginate(page: params[:page]).order(start_date: :desc)
    end
  end

  def show
    @job = Job.find(params[:id])
    @attempted_interpreters = @job.attempted_interpreters
    @confirmed_interpreters = @job.confirmed_interpreters
  end

  def new
    @job = Job.new
  end

  def new_job_from_job_request
    @job_request = JobRequest.find(params[:job_request_id])
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      flash[:info] = 'Job has been successfully created.'
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
      flash[:success] = 'Job Updated'
      redirect_to @job
    else
      render 'edit'
    end
  end

  def add_interpreter_to_job
    @job = Job.find(params[:id])
    @new_interpreter = User.find(params[:job][:confirmed_interpreters])
    @job.confirm_user(@new_interpreter)
    flash[:success] = "#{@new_interpreter.full_name_with_vendor_number} has been added to Job ##{@job.id}."
    redirect_to job_url(@job)
  end

  def remove_interpreter_from_job
    @job = Job.find(params[:id])
    @interpreter = User.find(params[:interpreter_id])
    @job.unconfirm_user(@interpreter)
    flash[:success] = "#{@interpreter.full_name_with_vendor_number} has been removed to Job ##{@job.id}."
    redirect_to job_url(@job)
  end

  def finalize_job_and_interpreters
    @job = Job.find(params[:id])
    @job.finalize_job_and_interpreters
    @job.confirmed_interpreters.each do |confirmed_interpreter|
      @job.complete_job(confirmed_interpreter)
    end
    @job.job_complete
    flash[:success] = 'This job has been finalized.'
    redirect_to job_url(@job)
  end

  def expire_job
    @job = Job.find(params[:id])
    @job.expire_job
    flash[:success] = "Job #{@job.id} has been expired."
    redirect_to jobs_url
  end

  def jobs_in_need_of_confirmed_interpreter; end

  def jobs_awaiting_invoice; end

  def processed_jobs; end

  def expired_jobs; end

  private

  def job_params
    params.require(:job).permit(:start_date, :start_time,
                                :requested_end_time,
                                :requester_first_name,
                                :requester_last_name, :requester_email,
                                :requester_phone_number,
                                :requester_phone_number_extension,
                                :contact_person_first_name,
                                :contact_person_last_name,
                                :address_line_1, :address_line_2,
                                :address_line_3, :city, :state, :zip,
                                :invoice_notes, :notes_for_irp,
                                :notes_for_interpreter, :directions,
                                :customer_id, :qast_1_interpreting_required,
                                :qast_2_interpreting_required,
                                :qast_3_interpreting_required,
                                :qast_4_interpreting_required,
                                :qast_5_interpreting_required,
                                :qast_1_transliterating_required_required,
                                :qast_2_transliterating_required,
                                :qast_3_transliterating_required,
                                :qast_4_transliterating_required,
                                :qast_5_transliterating_required,
                                :rid_ci_required, :rid_ct_required,
                                :rid_cdi_required, :di_required,
                                :nic_required, :nic_advanced_required,
                                :nic_master_required, :rid_sc_l_required,
                                :bei_required, :bei_advanced_required,
                                :bei_master_required)
  end

  def job_search
    @jobs = Job.search(params[:search][:query], params[:page]).order(start_date: :desc)
    if params[:search][:start_after].present?
      start_after_string = params[:search][:start_after].to_s
      start_after = DateTime.strptime(start_after_string, '%m-%d-%Y')
      @jobs = @jobs.where('start_date >= ?', start_after)
      if params[:search][:end_before].present?
        end_before_string = params[:search][:end_before].to_s
        end_before = DateTime.strptime(end_before_string, '%m-%d-%Y')
        @jobs = @jobs.where('start_date <= ?', end_before)
      end
    elsif params[:search][:end_before].present?
      end_before_string = params[:search][:end_before].to_s
      end_before = DateTime.strptime(end_before_string, '%m-%d-%Y')
      @jobs = @jobs.where('start_date <= ?', end_before)
    end
  end

  # Before filters

  # Confirms a logged-in user.
  def logged_in_user
    unless user_logged_in?
      store_location
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end

  # Confirms a manager user.
  def manager_user
    redirect_to(root_url) unless current_user.manager?
  end

  # Confirms a manager user, correct customer, or correct interpreter.
  def manager_correct_customer_or_interpreter
    @job = Job.find(params[:id])
    if current_user && current_user.manager?
      # Do Nothing
    elsif current_customer && current_customer.jobs.include?(@job)
      # Do Nothing
    elsif current_user && current_user.confirmed_jobs.include?(@job)
      # Do Nothing
    else
      redirect_to root_url
    end
  end
end
