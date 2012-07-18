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
    @filters_id = params[:filters_id]
    
  if !params[:filters_id].nil? 
      if cookies[:filters].blank?
        cookies[:filters] = (params[:filters_id] + ',')
      else
        cookies[:filters] = cookies[:filters] << (params[:filters_id] + ',') unless cookies[:filters].include?(params[:filters_id] + ',')
      end 
   end

   #set up search
   if params[:search].nil?  #GET /organizations -- params[:filters_id & :filters] also not null 
      if cookies[:filters].nil? || cookies[:filters].empty?
        @projects = Project.all
      else
        @projects = Project.filter(cookies[:filters])
      end
   else
     if !params[:search].empty? && params[:filters_id].empty? # search and no filters
        @projects = Project.search(params[:search])
     end

     if !params[:search].empty? && !params[:filters_id].empty? # search and filters
        @projects = Project.search_and_filter(cookies[:filters], params[:search])
     end

     if params[:search].empty? && !params[:filters_id].empty? #no search, filters
        @projects = Project.filter(cookies[:filters])
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
