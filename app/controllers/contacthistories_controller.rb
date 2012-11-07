class ContacthistoriesController < ApplicationController
  require 'will_paginate/array'
  before_filter :signed_in_user, only: [:create, :new, :destroy]

  # DELETE /contacthistories/1
  # DELETE /contacthistories/1.json
  def destroy
    @contacthistory = Contacthistory.find(params[:id])
    @organization = @contacthistory.organization

    redirect_to @organization, notice: 'You must be an admin of this organization to do that.' unless current_user.admin_of(@organization)

    @contacthistory.destroy

    respond_to do |format|
      format.html { redirect_to @organization, notice: 'Admin record successfully removed' }
      format.json { head :no_content }
    end
  end

  def create
    #@user_id = params[:contacthistory][:user_id]
    @user_email = params[:user_email]
    @user = User.find_by_email(@user_email)
    @organization_id = params[:contacthistory][:organization_id]
    @organization = Organization.find(@organization_id)
    @end_date = Date.new(params[:contacthistory][:"end_date(1i)"].to_i, 
                        params[:contacthistory][:"end_date(2i)"].to_i,
                        params[:contacthistory][:"end_date(3i)"].to_i)

    if !@user.nil?
      @admin = Contacthistory.create(user_id: @user.id, organization_id: @organization_id, start_date: Date.today, end_date: @end_date)
      if @admin.save


        Notifications.new_admin_email(@user, current_user, @organization, @end_date).deliver
        flash[:success] = "Admin Record Successfully Added. Email notification has been sent to new admin."
        redirect_to organization_url(@organization_id)
      else
        flash[:error] = "Error Adding this Admin. Make sure the admin does not already exist."
        redirect_to organization_url(@organization_id)
      end
    else
      flash[:error] = "Invalid User Email. No user exists with inputted email address. Please try again."
      redirect_to organization_url(@organization_id)
    end

  end

  def new
    @organization = Organization.find(params[:organization_id])
    @newadmin = @organization.build_contacthistory
  end

end
