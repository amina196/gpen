class Project < ActiveRecord::Base
	PROJ_TIME=['Day', 'Evening', 'Week-end', 'Flexible']
  	belongs_to :sector
  	belongs_to :user
  	belongs_to :organization
  	has_many :sectors, :through => :projectsectors, dependent: :destroy
  	has_many :projectsectors

  	#împlementing application to volunteer work
		has_many :projectenrollments, dependent: :destroy
		has_many :users, through: :projectenrollments


	#method for search
	
def self.filter(sector)
        sectorarray = sector.split(',')
        a = Projectsector.find_all_by_sector_id(sectorarray)
        b = a.collect {|orgsec| orgsec.organization}
        return b
  end

  def self.search(search)
        Project.find(:all, :conditions => ['title LIKE ? OR proj_desc LIKE ? OR city LIKE ? OR state LIKE ? or zip LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%" , "%#{search}%"])
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
# Table name: projects
#
#  id               :integer         not null, primary key
#  proj_time        :string(255)
#  proj_desc        :string(255)
#  address          :string(255)
#  city             :string(255)
#  state            :string(255)
#  zip              :string(255)
#  nb_people_needed :integer
#  min_age          :string(255)
#  start_date       :date
#  user_id          :integer
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  organization_id  :integer
#  title            :string(255)
#

