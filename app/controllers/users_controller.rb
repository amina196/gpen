class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:jobs]
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
    @user = User.new(params[:user])
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

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

end
