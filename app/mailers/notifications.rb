class Notifications < ActionMailer::Base
  default :from => "support@gpen.org"

  def welcome_email(user)
    @url = "http://gpen.phillyecocity.com"
    @user = user
    mail(:to => user.email, :subject => "Welcome to GPEN!")
  end

   def application_email_user(user, job, jobenrollment)
    @url = "http://gpen.phillyecocity.com"
    @user = user
    @job = job
    @organization = Organization.find(@job.organization_id)
    @jobenrollment = jobenrollment
    attachments[@jobenrollment.resume_file_name] = open(@jobenrollment.resume.url).read
    mail(:to => user.email, :subject => "[GPEN] Job Application Submitted for: " + @job.title)
  end


  def application_email_admin(user, job, jobenrollment)
    @url = "http://gpen.phillyecocity.com"
    @user = user
    @job = job
    @organization = Organization.find(@job.organization_id)
    @email = @organization.email
    @jobenrollment = jobenrollment

    # test if organization email exists!!!
    attachments[@jobenrollment.resume_file_name] = open(@jobenrollment.resume.url).read
    mail(:to => 'justin@relativecommotion.com', :subject => "[GPEN] Job Application Received for: " + @job.title)
  end

  def resetpswd_email(user, new_pass)
    @user = user
    @new_pass = new_pass
    mail(:to => user.email, :subject => "Your GPEN password has been modified")
  end
end
