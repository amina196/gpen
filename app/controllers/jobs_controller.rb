class JobsController < ApplicationController
  before_filter :org_admin, only: [:new, :create, :update, :edit, :destroy]
  
  def index
   
    @searchtext = params[:search]
    @sectors = Sector.all
    @filters_ids = [] # array of ids of filters we are searching on
    @filters_string = "" # string of comma separated filters we are searching on
    @filters_obj = [] # array of objs of filters we are searching on


    # check to see if any cookies exist
    if !cookies[:filters_string].nil? && !cookies[:filters_string].empty?
      @filters_ids = cookies[:filters_string].split(',').collect { |stringid| stringid.to_i}
      @filters_string = cookies[:filters_string]
      @filters_obj = @filters_ids.collect {|id| Sector.find(id)}.uniq # used for showing labels of filters activated in view
    end
  
    # if this is a new submitted search, take in the params and overwrite any cookies
    if !params[:filters_string].nil? && !params[:filters_string].empty?
      @filters_ids = params[:filters_string].split(',').collect { |stringid| stringid.to_i}
      @filters_string = params[:filters_string]
      cookies[:filters_string] = params[:filters_string] # replace cookies with current submitted filters
      @filters_obj = @filters_ids.collect {|id| Sector.find(id)}.uniq # used for showing labels of filters activated in view
    end 


   #set up jobs search
   if @searchtext.nil? || @searchtext.empty?
      if @filters_string.nil? || @filters_string.empty?
        @jobs = Job.search('') # no search, and no filters
      else
        @jobs = Job.filter(@filters_string) # no search, and filters
      end
   else
     if @filters_string.nil? || @filters_string.empty? 
        @jobs = Job.search(@searchtext) # search and no filters
     else 
        @jobs = Job.search_and_filter(@filters_string, @searchtext) # search and filters
     end
   end


  
  end

  def resetcookies
    cookies[:filters_string] = nil
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
      flash[:success] = "The job you posted has been saved successfully!"
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