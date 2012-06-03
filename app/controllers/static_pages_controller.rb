class StaticPagesController < ApplicationController

  def home
    @user = User.new
    @latest_orgs = Organization.find(:all, :order => "updated_at desc", :limit => 5)
    @latest_jobs = Job.find(:all, :order => "updated_at desc", :limit => 5)
    @latest_projects = Project.find(:all, :order => "updated_at desc", :limit => 5)
  end

  def about
  end

  def profile
  end

  def create_org
  end

  def browse_orgs
  end

  def org_profile
  end

  def list_orgs
  end

  def create_job
  end

  def browse_jobs
  end

  def list_jobs
  end

  def single_job
  end

  def single_project
  end
  
end
