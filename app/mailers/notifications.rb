class Notifications < ActionMailer::Base
  default :from => "welcome@gpen.org"
  def welcome_email(user)
    @url = "http://gpen.phillyecocity.com"
    @user = user
    mail(:to => user.email, :subject => "Welcome to GPEN!")
  end

   def application_email(user, job)
    @url = "http://gpen.phillyecocity.com"
    @user = user
    @job = job
    @organization = Organization.find(@job.organization_id)
    mail(:to => user.email, :subject => "Application on GPEN job")
  end
end
