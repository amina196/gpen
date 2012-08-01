class JobsController < ApplicationController
  before_filter :org_admin, only: [:new, :create, :update, :edit, :destroy]
  
  def index
   
    @sectors = Sector.all
    @searchedjobs = Job.search(params[:search])
    @searchtext = params[:search]
    @filters_id = params[:filters_id]


if !params[:filters_id].nil? 
      if cookies[:filters].blank?
        cookies[:filters] = (params[:filters_id] + ',') unless params[:filters_id].empty?
      else
        cookies[:filters] = cookies[:filters] << (params[:filters_id] + ',') unless cookies[:filters].include?(params[:filters_id] + ',')
      end 
   end

   #set up search : ONLY JOBS WHOSE ORG HAS BEEN APPROVED
   if params[:search].nil?  #GET /organizations -- params[:filters_id & :filters] also not null 
      if cookies[:filters].nil? || cookies[:filters].empty?
        @jobs = Job.all  #jobs whose organization has been approved 
      else
        @jobs = Job.filter(cookies[:filters])
      end
   else
     if !params[:search].empty? && params[:filters_id].empty? # search and no filters
        @jobs = Job.search(params[:search])
     end

     if !params[:search].empty? && !params[:filters_id].empty? # search and filters
        @jobs = Job.search_and_filter(cookies[:filters], params[:search])
     end

     if params[:search].empty? && !params[:filters_id].empty? #no search, filters
        @jobs = Job.filter(cookies[:filters])
     end
   end

   #get array of string for showing labels of filters activated
   if cookies[:filters].nil? || cookies[:filters].empty?
     @filters = []
   else
     @filters = ((cookies[:filters].split(',').collect { |stringid| stringid.to_i}).collect { |id| Sector.find(id)}).uniq
   end
     

   @searchtext = params[:search]
   @sectors = Sector.all
   @filters_id = params[:filters_id]
  end

  def resetcookies
    cookies[:filters] = nil
    redirect_to jobs_path
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