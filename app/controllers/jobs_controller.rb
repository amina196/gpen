class JobsController < ApplicationController
  before_filter :org_admin, only: [:new, :create, :update, :edit, :destroy]

  def index
    @jobs = Job.all
    @searchedjobs = Job.search(params[:search])
    @searchtext = params[:search]
    render 'list_jobs' unless @searchedjobs.nil?
  end

  def show
    @job = Job.find(params[:id])
  end

  def new
    @job = Job.new
  end

  def edit
    @job = Job.find(params[:id])
    if !current_user.admin_of(@job.organization)
      flash[:notice] = "You are not authorized to update this job."
      redirect_to @job
    end
  end

  def create

    @job = Job.create(params[:job])
    @job.sectors = Sector.find(params[:sector_ids]) if params[:sector_ids]
    if @job.save
      flash[:success] = "Job created!"
      redirect_to @job
    else
      render 'jobs/new'
    end
  end

  def update
    @job = Job.find(params[:id])
    if !current_user.admin_of(@job.organization)
      flash[:notice] = "You are not authorized to update this job."
      redirect_to @job
    else
      @job.sectors = Sector.find(params[:sector_ids]) if params[:sector_ids]
      if @job.update_attributes(params[:job])
        flash[:success] = "Job updated!"
        redirect_to @job
      else
        flash[:notice] = "Job could not be updated."
        redirect_to @job
      end
    end
  end

  def destroy
    @job = Job.find(params[:id])
    if !current_user.admin_of(@job.organization)
      flash[:notice] = "You are not authorized to view that page."
      redirect_to jobs_path
    end
    @job.destroy
    redirect_to jobs_path
  end
end