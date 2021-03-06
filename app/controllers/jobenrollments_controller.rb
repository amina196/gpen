class JobenrollmentsController < ApplicationController

  def create
  	@job = Job.find(params[:jobenrollment][:job_id])
    @jobenrollment = current_user.jobenrollments.create(params[:jobenrollment])
        
    if @jobenrollment.save
      Notifications.application_email_user(current_user, @job, @jobenrollment).deliver
      Notifications.application_email_admin(current_user, @job, @jobenrollment).deliver
      flash[:success] = "You have successfully applied to this job! Contact the organization admin directly if you are not contacted in 3-5 business days."
      redirect_to @job
    else
      flash[:error] = "Error: Please attach a resume file before applying."
      redirect_to @job
    end



    #job_id: @job.id,resume_file_name: params[:jobenrollment][:resume].original_filename, resume_content_type: params[:jobenrollment][:resume].content_type
  end

  def destroy
  	@job = Jobenrollment.find(params[:id]).job
    current_user.unapply!(@job)
    redirect_to @job
  end
   
end


