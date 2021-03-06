class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:jobs, :projects, :organizations]
  before_filter :admin_user, only: [:index]
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @jobs = @user.jobs
    @posted_projects = @user.posted_projects
    @projects = @user.projects
    @job_suggestions = @user.jobs
  end

  def new
    @user = User.new
  end
  
  def create
    if params[:user][:botfisher].empty? 
      h = params[:user]
      h.delete("botfisher")
      @user = User.new(h)
      if @user.save
        @user.update_attribute(:confirmed, false)
        Notifications.welcome_email(@user).deliver
        #sign_in @user
        flash[:success] = "Welcome to GPEN, #{@user.fname}! Please confirm your account for full access to the GPEN website"
        redirect_to root_path
      else
        render 'new'
      end
    end
  end

  def confirm
    @user = User.find_by_verification_token(params[:token])
    @user.update_attribute(:confirmed, true) 
    if @user.confirmed == true  
      sign_in(@user)
      flash[:success] = "Your account has been successfully confirmed - You can now access the full GPEN database"
    else
      flash[:error] = "There has been a problem confirming your account "
    end 
    redirect_to root_path
  end

  def resetpswd
    if request.get?
      render 'resetpswd'
    end

    if request.post?
      @user = User.find_by_email(params[:user][:email])
      if @user.nil?
        flash[:error] = "The email address entered is not a GPEN account."
        redirect_to request.referer
      else
        new_pass = SecureRandom.urlsafe_base64
        @user.update_attributes(password: new_pass, password_confirmation: new_pass)
        flash[:notice] = "A new password has been sent to your email inbox !"
        Notifications.resetpswd_email(@user, new_pass).deliver
        redirect_to root_path
      end
    end

  end

  def jobs
    @user = User.find(params[:id])
    @jobs = @user.jobs
    render 'show_application'
  end

  def projects
    @user = User.find(params[:id])
    @projects= @user.projects
    render 'show_volunteering'
  end

  def organizations
    @user = User.find(params[:id])
    @organizations = @user.organizations
    render 'show_organizations'
  end

  def edit
    @user = User.find(params[:id])

    if !(!current_user.nil? && (current_user.admin == true || current_user.id == @user.id))
      flash[:error] = "You are not authorized to edit this user's profile."
      redirect_to @user
    end

  end

  def update
    if params[:user][:botfisher].empty? 
      h = params[:user]
      h.delete("botfisher")
      @user = User.find(params[:id])
      respond_to do |format|
        if @user.update_attributes(h)
          format.html { redirect_to @user, notice: 'Your profile was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: 'Profile successfully destroyed.' }
      format.json { head :no_content }
    end
  end

end
