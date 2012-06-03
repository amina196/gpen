class JobenrollmentsController < ApplicationController

  def create
  	@job = Job.find(params[:jobenrollment][:job_id])
    current_user.apply!(@job)
    redirect_to @job
  end

  def destroy
  	@job = Jobenrollment.find(params[:id]).job
    current_user.unapply!(@job)
    redirect_to root_path
  end
  
end


