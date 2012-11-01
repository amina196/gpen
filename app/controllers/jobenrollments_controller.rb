class JobenrollmentsController < ApplicationController

  def create
  	@job = Job.find(params[:jobenrollment][:job_id])
    @jobenrollment = current_user.jobenrollments.create!(params[:jobenrollment])
    Notifications.application_email_user(current_user, @job, @jobenrollment).deliver
    Notifications.application_email_admin(current_user, @job, @jobenrollment).deliver
    redirect_to @job

    #job_id: @job.id,resume_file_name: params[:jobenrollment][:resume].original_filename, resume_content_type: params[:jobenrollment][:resume].content_type
  end

  def destroy
  	@job = Jobenrollment.find(params[:id]).job
    current_user.unapply!(@job)
    redirect_to @job
  end
   
end


