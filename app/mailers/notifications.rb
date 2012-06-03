class Notifications < ActionMailer::Base
  default :from => "welcome@gpen.org"
  def welcome_email(user)
    @url = "http://gpen.phillyecocity.com"
    @user = user
    mail(:to => user.email, :subject => "Welcome to GPEN!")
  end
end
