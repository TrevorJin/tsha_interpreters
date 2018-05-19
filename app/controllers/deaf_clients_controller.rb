class DeafClientsController < ApplicationController
  before_action :logged_in_user,
    only: [:index, :show, :new, :create, :edit, :update,
           :jobs_in_need_of_confirmed_interpreter, :jobs_awaiting_invoice,
           :processed_jobs, :expired_jobs]
  before_action :manager_user,
    only: [:index, :show, :new, :create, :edit, :update,
           :finalize_job_and_interpreters, :expire_job,
           :jobs_in_need_of_confirmed_interpreter, :jobs_awaiting_invoice,
           :processed_jobs, :expired_jobs]
  before_action :manager_dashboard,
    only: [:index, :show, :new, :new_job_from_job_request, :create, :edit,
           :jobs_in_need_of_confirmed_interpreter, :jobs_awaiting_invoice,
           :processed_jobs, :expired_jobs]
  before_action :update_job_and_job_request_statuses,
    only: [:index, :show, :new, :create, :jobs_in_need_of_confirmed_interpreter,
           :jobs_awaiting_invoice, :processed_jobs, :expired_jobs]

  def index
    # Manager Search
    if params[:search]
      @deaf_clients = DeafClient.search(params[:search], params[:page]).order(last_name: :asc)
    else
      @deaf_clients = DeafClient.paginate(page: params[:page]).order(last_name: :asc)
    end
  end

  def show
    @deaf_client = DeafClient.find(params[:id])
  end

  def new
    @deaf_client = DeafClient.new
  end

  def create
    @deaf_client = DeafClient.new(deaf_client_params)
    if @deaf_client.save
      flash[:info] = 'Deaf client has been successfully created.'
      redirect_to deaf_clients_url
    else
      render 'new'
    end
  end

  def edit
    @deaf_client = DeafClient.find(params[:id])
  end

  def update
    @deaf_client = DeafClient.find(params[:id])
    if @deaf_client.update_attributes(deaf_client_params)
      flash[:success] = 'Deaf Client Updated'
      redirect_to @deaf_client
    else
      render 'edit'
    end
  end

  private

  def deaf_client_params
    params.require(:deaf_client).permit(:first_name, :last_name,
                                        :internal_notes,
                                        :public_notes)
  end

  # Before filters

  # Confirms a logged-in user.
  def logged_in_user
    unless user_logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # Confirms a manager user.
  def manager_user
    redirect_to(root_url) unless current_user && current_user.manager?
  end
end
