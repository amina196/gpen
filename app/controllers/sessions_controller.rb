class SessionsController < ApplicationController
def new
end

def create
  user = User.find_by_email(params[:session][:email])
  if user && user.authenticate(params[:session][:password]) && user.confirmed
    # Sign the user in and redirect to the user's show page.
    sign_in user
    redirect_to user
  else
      if user.confirmed == false
        flash[:notice] = 'Please confirm your email first for full use of the GPEN website' 
        redirect_to root_path
      else
        flash.now[:error] = 'Invalid email/password combination'
        render 'new'
      end
      
  end
end

def destroy
    sign_out
    redirect_to root_path
  end
end
