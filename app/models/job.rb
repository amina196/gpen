class Job < ActiveRecord::Base
  STATUS=['Full-time', 'Part-time', 'Contract']
  AVAILABILITY=['Available', 'Unavailable']

  #one to many relationship with the organization model
  belongs_to :organization
  
  #implementing job applications
  has_many :jobenrollments, dependent: :destroy
  has_many :users, :through => :jobenrollments

  #implementing many-to-many between jobs and sectors
  has_many :jobsectors, dependent: :destroy
  has_many :sectors, through: :jobsectors

  validates :organization_id, :presence => true
  validates :title, :presence => true
  validates :status, :presence => true
  validates :availability, :presence => true

  def self.search(search)
      if search
        find(:all, conditions: [' UPPER(title) LIKE UPPER(?) OR UPPER(description) LIKE UPPER(?)', "%#{search}%", "%#{search}%"])
      else
        nil #how do we return the empty set ?!
      end
  end  
end
