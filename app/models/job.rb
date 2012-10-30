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

   
  ###### old method
  # def self.filter(sector)
  #       sectorarray = sector.split(',')
  #       a = Jobsector.find_all_by_sector_id(sectorarray)
  #       b = a.collect {|jobsec| jobsec.job}
  #       return b
  # end

  ###### new method
  def self.filter(sector)
        sectorarray = sector.split(',')
        return Job.joins(:sectors)
                  .where('sectors.id' => sectorarray)
                  .group('jobs.id')
                  .having('COUNT(jobs.id) = ?', sectorarray.size)
  end

  ###### new method
  def self.search(search)
    if search.empty?
      ###### NEEDS TO ONLY DISPLAY JOBS WHOSE ORG HAS BEEN 1) APPROVED AND 2) HAS NOT EXPIRED
      #Organization.where('approved = ? AND end_date > ?', true, Date.today) # get only orgs that have been approved and have not expired
      Job.find(:all)
    else
      Job.find(:all, :conditions => [' UPPER(title) LIKE UPPER(?) OR UPPER(description) LIKE UPPER(?)', "%#{search}%", "%#{search}%"])
    end
  end

  ###### old method
  # def self.search_and_filter(sector, search)
  #     sectors = sector.split(',')
  #     result = []
  #     searchresult = self.search(search)
  #     searchresult.each do |o|
  #       sector_ids = o.sectors.collect {|sector| sector.id.to_s}
  #       sector_ids.each do |s| 
  #         if sectors.include?(s) 
  #           result = result << o
  #           break
  #         end
  #       end
  #     end
  #     return result
  # end

  
  ###### new method
  def self.search_and_filter(sector, search)
    sectorarray = sector.split(',')

    #first search results then filter them down by the sectors
    results = Job.joins(:sectors)
        .where('sectors.id' => sectorarray)
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

