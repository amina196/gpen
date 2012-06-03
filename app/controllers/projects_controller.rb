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
    @projectsearched = Project.search(params[:search])
    @projects = Project.all
    render 'list_projects' unless @projectsearched.nil?
    @searchtext = params[:search]

    
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
