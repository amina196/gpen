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

  def new_admin_email(admin, current_user, organization, end_date)
    @admin = admin
    @current_user = current_user
    @organization = organization
    @end_date = end_date

    mail(:to => admin.email, :cc => current_user.email, :subject => "[GPEN] You were made an admin of: " + @organization.name)
  end


  def application_email_admin(user, job, jobenrollment)
    @url = "http://gpen.phillyecocity.com"
    @user = user
    @job = job
    @organization = Organization.find(@job.organization_id)
    @jobenrollment = jobenrollment

    @email = ""
    # for now, if org has admin, send to the first one, else send to the default org email list, else send nothing
    if @organization.users.any? && !@organization.users.first.email.nil? && !@organization.users.first.email.empty?
      @email = @organization.users.first.email
    else
      @email = @organization.email
    end

    if !@email.nil? && !@email.empty?
      attachments[@jobenrollment.resume_file_name] = open(@jobenrollment.resume.url).read
      mail(:to => @email, :subject => "[GPEN] Job Application Received for: " + @job.title)
    end

  end

  def resetpswd_email(user, new_pass)
    @user = user
    @new_pass = new_pass
    mail(:to => user.email, :subject => "Your GPEN password has been modified")
  end
end
