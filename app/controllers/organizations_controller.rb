class OrganizationsController < ApplicationController
  require 'will_paginate/array'
  before_filter :signed_in_user, only: [:create, :new, :update, :edit, :destroy]
 
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

   #set up organizations search
   if @searchtext.nil? || @searchtext.empty?
      if @filters_string.nil? || @filters_string.empty?
        @organizations = Organization.search('') # no search, and no filters
      else
        @organizations = Organization.filter(@filters_string) # no search, and filters
      end
   else
     if @filters_string.nil? || @filters_string.empty? 
        @organizations = Organization.search(@searchtext) # search and no filters
     else 
        @organizations = Organization.search_and_filter(@filters_string, @searchtext) # search and filters
     end
   end


  end


  def resetcookies
    cookies[:filters_string] = nil
    redirect_to organizations_path
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    @organization = Organization.find(params[:id])
    #@newadmin = @organization.contacthistories.new
    @newadmin = Contacthistory.new
    @newadmin.organization_id = @organization.id
    
    if @organization.approved == false || @organization.end_date < Date.today
        if !current_user.nil?
          if (!current_user.admin_of(@organization))
             redirect_to organizations_path 
             flash[:notice] = "This organization will be visible after it has been approved or renewed."
          end
        else 
            redirect_to organizations_path 
            flash[:notice] = "This organization will be visible after it has been approved or renewed."
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
      
      if @organization.save
        flash[:success] = sprintf("Successfully renewed %s for %i months from today.", @organization.name, params[:months])
        redirect_to @organization
      else
        flash[:error] = sprintf("Error renewing organization. Please make sure this organization has all its required attributes filled in.")
        redirect_to @organization
      end
    end
  end



  def renew_three
    @organization = Organization.find(params[:organization_id])
    @organization.renew(3)
    
    if @organization.save
      flash[:success] = sprintf("Successfully renewed %s for %i months from today.", @organization.name, 3)
      redirect_to @organization
    else
      flash[:error] = sprintf("Error renewing organization. Please make sure this organization has all its required attributes filled in.")
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
      Contacthistory.create(user_id: current_user.id, organization_id: @organization.id, start_date: Date.today, end_date: nil)
      flash[:success] = "Organization created! You are now an admin of this organization. Your organization will not show up in search results until it has been approved by the GPEN administration."
      redirect_to @organization
    else
      render 'organizations/new'
    end
  end

  def approve
    @organization = Organization.find(params[:organization_id])
    @organization.update_attributes(
      approved: true,
      end_date: Date.today + 3.months
    )
    @organization.contacthistories.each do |ch|
      ch.update_attributes(
        :start_date => Date.today
      )
    end
    
    if @organization.save
        flash[:success] = "You successfully temporaily approved: " + @organization.name + ". This organization will expire in 3 months. Add more time by using the Renew Membership function in the Admin Actions dropdown."
        redirect_to @organization
      else
        flash[:error] = sprintf("Error approving organization. Please make sure this organization has all its required attributes filled in.")
        redirect_to @organization
      end
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
