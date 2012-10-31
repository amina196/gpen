class ProjectsController < ApplicationController
   before_filter :signed_in_user, only: [:create, :new, :update, :edit, :destroy]
  
  def new
    @project = current_user.posted_projects.build
  end

  def create
    @project = current_user.posted_projects.build(params[:project])
    somedate = Date.new(params[:project][:"start_date(1i)"].to_i, 
                   params[:project][:"start_date(2i)"].to_i,
                   params[:project][:"start_date(3i)"].to_i)
    if params[:project][:organization_id].nil? || params[:project][:organization_id].empty?
      @project = current_user.posted_projects.build(proj_time: params[:project][:proj_time],
                                                    proj_desc: params[:project][:proj_desc],
                                                    address: params[:project][:address],
                                                    title: params[:project][:title],
                                                    city: params[:project][:city],
                                                    state: params[:project][:state],
                                                    zip: params[:project][:zip],
                                                    nb_people_needed: params[:project][:nb_people_needed],
                                                    min_age: params[:project][:min_age],
                                                    start_date: somedate,
                                                    user_id: current_user.id,
                                                    organization_id: nil
                                                   )
    end
    @project.sectors = Sector.find(params[:sector_ids]) if params[:sector_ids]
    if @project.save
      flash[:success] = "Project successfully posted"
      redirect_to @project       
    else
      render 'static_pages/home'
    end
  end

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
    if !params[:filters_string].nil?
      @filters_ids = params[:filters_string].split(',').collect { |stringid| stringid.to_i}
      @filters_string = params[:filters_string]
      cookies[:filters_string] = params[:filters_string] # replace cookies with current submitted filters
      @filters_obj = @filters_ids.collect {|id| Sector.find(id)}.uniq # used for showing labels of filters activated in view
    end 


    #set up projects search
    if @searchtext.nil? || @searchtext.empty?
      if @filters_string.nil? || @filters_string.empty?
        @projects = Project.search('') # no search, and no filters
      else
        @projects = Project.filter(@filters_string) # no search, and filters
      end
    else
      if @filters_string.nil? || @filters_string.empty? 
        @projects = Project.search(@searchtext) # search and no filters
      else 
        @projects = Project.search_and_filter(@filters_string, @searchtext) # search and filters
      end
     end
  end
 
  def resetcookies
    cookies[:filters_string] = nil
    redirect_to projects_path
  end


  def update
    @project = Project.find(params[:id])
    unless @project.user_id == current_user.id || current_user.admin_of(@project.organization)
      flash[:notice] = "You are not authorized to update this project."
      redirect_to @project
    else
      @project.sectors = Sector.find(params[:sector_ids]) if params[:sector_ids]
      if @project.update_attributes(params[:job])
        flash[:success] = "Project updated!"
        redirect_to @project
      else
        flash[:notice] = "Project could not be updated."
        redirect_to @project
      end
    end
  end

  def show
    @project = Project.find(params[:id])
  end

  def edit
    @project = Project.find(params[:id])
    if !(current_user.id == @project.user_id || current_user.admin_of(@project.organization))
      flash[:notice] = "You are not authorized to update this project."
      redirect_to @project
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to projects_path
  end

end
