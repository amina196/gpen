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

   
  def self.filter(sector)
        sectorarray = sector.split(',')
        return Job.joins(:sectors, :organization)
                  .where('sectors.id' => sectorarray)
                  .where('organizations.approved = ? AND organizations.end_date > ?', true, Date.today)
                  .group('jobs.id')
                  .having('COUNT(jobs.id) = ?', sectorarray.size)
  end

  def self.search(search)
    if search.empty?
      # show all jobs that have orgs that have been approved and have not expired
      Job.joins(:organization).where('organizations.approved = ? AND organizations.end_date > ?', true, Date.today)
    else
      Job.joins(:organization)
          .where('organizations.approved = ? AND organizations.end_date > ?', true, Date.today)
          .where('UPPER(title) LIKE UPPER(?) OR UPPER(jobs.description) LIKE UPPER(?)', "%#{search}%", "%#{search}%")
    end
  end

  def self.search_and_filter(sector, search)
    sectorarray = sector.split(',')

    #first search results then filter them down by the sectors
    results = Job.joins(:sectors, :organization)
        .where('sectors.id' => sectorarray)
        .where('organizations.approved = ? AND organizations.end_date > ?', true, Date.today)
        .where('UPPER(title) LIKE UPPER(?) OR UPPER(jobs.description) LIKE UPPER(?)', "%#{search}%", "%#{search}%")
        .group('jobs.id')
        .having('COUNT(jobs.id) = ?', sectorarray.size)
    return results
  end




end

# == Schema Information
#
# Table name: jobs
#
#  id              :integer         not null, primary key
#  title           :string(255)
#  description     :text(255)
#  status          :string(255)
#  availability    :string(255)
#  organization_id :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  start_date      :date
#  compensation    :string(255)
#

