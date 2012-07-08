class User < ActiveRecord::Base

attr_accessible :fname, :lname, :phone, :birth_date, :email, :password, :password_confirmation, :bio, :id, :facebook, :twitter, :linkedin, :website

has_secure_password

before_save :create_remember_token

valid_website_regex = /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix
validates :website, format: { with: valid_website_regex}
validates :fname, presence: true, length: { maximum: 50 }
validates :lname, presence: true, length: { maximum: 50 }
valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
validates :email,  presence:   true,
                   format:     { with: valid_email_regex },
                   uniqueness: { case_sensitive: false }
#validates :phone, presence: true
#validates :birth_date, presence: true
validates :password, length: { minimum: 6 }
validates :password_confirmation, presence: true

#implementing organization admins
has_many :contacthistories, dependent: :destroy
has_many :organizations, :through => :contacthistories

#implementing job applications
has_many :jobenrollments, dependent: :destroy
has_many :jobs, :through => :jobenrollments

#implementing posting of volunteering work
has_many :posted_projects, dependent: :destroy, class_name: "Project" #these are the POSTED projects

#împlementing application to volunteer work
has_many :projectenrollments, dependent: :destroy
has_many :projects, through: :projectenrollments

def has_applied?(job)
    jobenrollments.find_by_job_id(job.id)
end

def apply!(job)
	jobenrollments.create!(job_id: job.id)
end

def unapply!(job)
    jobenrollments.find_by_job_id(job.id).destroy
end

def has_volunteered?(project)
	projectenrollments.find_by_project_id(project.id)
end

def volunteer!(project)
	projectenrollments.create(project_id: project.id)
end

def unvolunteer!(project)
	projectenrollments.find_by_project_id(project.id).destroy
end

def current_organizations()
	if self.admin
		Organization.all
	else
		chs = contacthistories.all.select{ |c| c.current? }
		chs.collect{ |ch| ch.organization }
	end
end

def admin_of(org)
	current_organizations().include?(org) || (self.admin)
end

def proj_admin(proj)
	posted_projects.include?(proj) || (self.admin)
end

def confirm
	self.confirmed = true
end

private

	def create_remember_token
		self.remember_token = SecureRandom.urlsafe_base64
	end

end
# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  fname           :string(255)
#  lname           :string(255)
#  birth_date      :date
#  email           :string(255)
#  phone           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean
#  facebook        :string(255)
#  twitter         :string(255)
#  linkedin        :string(255)
#  bio             :string(1000)
#  website         :string(255)
#

