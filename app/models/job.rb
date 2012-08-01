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
        a = Jobsector.find_all_by_sector_id(sectorarray)
        b = a.collect {|jobsec| jobsec.job}
        return b
  end

  def self.search(search)
        Job.find(:all, :conditions => [' UPPER(title) LIKE UPPER(?) OR UPPER(description) LIKE UPPER(?)', "%#{search}%", "%#{search}%"])
  end

  def self.search_and_filter(sector, search)
      sectors = sector.split(',')
      result = []
      searchresult = self.search(search)
      searchresult.each do |o|
        sector_ids = o.sectors.collect {|sector| sector.id.to_s}
        sector_ids.each do |s| 
          if sectors.include?(s) 
            result = result << o
            break
          end
        end
      end
      return result
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

