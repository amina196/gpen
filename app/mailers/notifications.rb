class Notifications < ActionMailer::Base
  default :from => "support@gpen.org"

  def welcome_email(user)
    @url = "http://gpen.phillyecocity.com"
    @user = user
    mail(:to => user.email, :subject => "Welcome to GPEN!")
  end

   def application_email(user, job, jobenrollment)
    @url = "http://gpen.phillyecocity.com"
    @user = user
    @job = job
    @organization = Organization.find(@job.organization_id)
    @jobenrollment = jobenrollment
    attachments['resume.pdf'] = File.read(@jobenrollment.resume.url)
    mail(:to => user.email, :subject => "Application on GPEN job")
  end

  def resetpswd_email(user, new_pass)
    @user = user
    @new_pass = new_pass
    mail(:to => user.email, :subject => "Your GPEN password has been modified")
  end
end
