class Sector < ActiveRecord::Base
 
	#implementing many-to-many between jobs and organizations
  has_many :organizationsectors
  has_many :organizations, :through => :organizationsectors

  has_many :projectsectors
  has_many :projects, :through => :projectsectors

#implementing many-to-many between jobs and sectors
 has_many :jobsectors
 has_many :jobs, through: :jobsectors
 
end# == Schema Information
#
# Table name: sectors
#
#  id          :integer         not null, primary key
#  description :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

