class OrganizationsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :new, :update, :edit, :destroy]

 
  def index

   @searchtext = params[:search]
   @sectors = Sector.all
   @filters_id = params[:filters_id]
   #collect filters if any 
   if !params[:filters_id].nil?
      if cookies[:filters].blank?
        cookies[:filters] = (params[:filters_id] + ',') unless params[:filters_id].empty?
      else
        cookies[:filters] = cookies[:filters] << (params[:filters_id] + ',') unless cookies[:filters].include?(params[:filters_id] + ',')
      end 
   end

   #set up search
   if params[:search].nil?  #GET /organizations -- params[:filters_id & :filters] also not null 
      if cookies[:filters].nil? || cookies[:filters].empty?
        @organizations = Organization.where('approved = ?', true)
      else
        @organizations = Organization.filter(cookies[:filters])
      end
   else
     if !params[:search].empty? && params[:filters_id].empty? # search and no filters
        @organizations = Organization.search(params[:search])
     end

     if !params[:search].empty? && !params[:filters_id].empty? # search and filters
        @organizations = Organization.search_and_filter(cookies[:filters], params[:search])
     end

     if params[:search].empty? && !params[:filters_id].empty? #no search, filters
        @organizations = Organization.filter(cookies[:filters])
     end
   end

   #get array of string for showing labels of filters activated
   if cookies[:filters].nil? || cookies[:filters].empty?
     @filters = []
   else
    @filters_1 = cookies[:filters].split(',').collect { |stringid| stringid.to_i}
    @filters = @filters_1.collect {|id| Sector.find(id)}.uniq
   end
     
  end
 
  def resetcookies
    cookies[:filters] = nil
    redirect_to organizations_path
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    @organization = Organization.find(params[:id])
    if @organization.approved == false
        if !current_user.nil?
          if (current_user.admin == nil)
             redirect_to organizations_path 
             flash[:notice] = "This organization will be visible after it has been approved"
          end
        else 
            redirect_to organizations_path 
            flash[:notice] = "This organization will be visible after it has been approved"
        end
    end

    @date = @organization.end_date unless @organization.nil?
    @jobs = @organization.jobs
    @projects = @organization.projects
    @sectors = @organization.sectors
  end

  def renew
    @organization = Organization.find(params[:organization_id])
    if !current_user.admin_of(@organization) 
      redirect_to root_path 
    else
      @organization.renew(params[:months])
      @organization.save
      flash[:success] = sprintf("Successfully renewed %s for %i months.", @organization.name, params[:months])
      redirect_to @organization
    end
  end

  # GET /organizations/new
  # GET /organizations/new.json
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
    @organization = Organization.find(params[:id])
    redirect_to root_path unless current_user.admin_of(@organization)
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.create(params[:organization])
    @organization.approved = false
    @organization.sectors = Sector.find(params[:sector_ids]) if params[:sector_ids]
    if @organization.save
      Contacthistory.create(user_id: current_user.id, organization_id: @organization.id)
      flash[:success] = "Organization created!"
      redirect_to @organization
    else
      render 'organizations/new'
    end
  end

  def approve
    @organization = Organization.find(params[:organization_id])
    @organization.update_attributes(
      approved: true,
      end_date: @organization.created_at + 3.months
    )
    @organization.contacthistories.each do |ch|
      ch.update_attributes(
        :start_date => Date.today
      )
    end
    flash[:success] = "You successfully approved: " + @organization.name
    redirect_to organizations_path
  end

  # PUT /organizations/1
  # PUT /organizations/1.json
  def update
    @organization = Organization.find(params[:id])
    @organization.sectors = Sector.find(params[:sector_ids]) if params[:sector_ids]
    respond_to do |format|
      if @organization.update_attributes(params[:organization])
        format.html { redirect_to @organization, notice: 'Organization was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy

    respond_to do |format|
      format.html { redirect_to organizations_url }
      format.json { head :no_content }
    end
  end
end
