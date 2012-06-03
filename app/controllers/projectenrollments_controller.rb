class ProjectenrollmentsController < ApplicationController
  before_filter :signed_in_user

  def create
    @project = Project.find(params[:projectenrollment][:project_id])
    current_user.volunteer!(@project)
    flash[:success] = "You have successfully volunteered for this project. Thanks!"
    redirect_to @project
  end

  def destroy
    @project = Projectenrollment.find(params[:id]).project
    current_user.unvolunteer!(@project)
    flash[:notice] = "You have successfully unvolunteered for this project. Hope you can make it next time!"
    redirect_to @project
  end
end