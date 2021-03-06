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


    # search methods will only display user projects (organization_id is null) or org projects for the orgs have been approved and have not expired

  def self.filter(sector)
        sectorarray = sector.split(',')

        return Project.select('projects.*')
                    .joins(:sectors)
                    .with_organizations
                    .where('sectors.id' => sectorarray)
                    .where('(organizations.approved = ? AND organizations.end_date > ?) OR organization_id is null', true, Date.today)
                    .group('projects.id')
                    .having('COUNT(projects.id) = ?', sectorarray.size)

        # old method!!
        # return Project.select('projects.*')
        #           .joins(:sectors).includes(:organization)
        #           .where('sectors.id' => sectorarray)
        #           .where('(organizations.approved = ? AND organizations.end_date > ?) OR organization_id is null', true, Date.today)
        #           .group('projects.id')
        #           .having('COUNT(projects.id) = ?', sectorarray.size)
  end

  def self.search(search)
    if search.empty?
      # show all user projects (organization_id is null), and show all org projects for the orgs have been approved and have not expired
      Project.includes(:organization)
              .select('projects.*')
              .where('(organizations.approved = ? AND organizations.end_date > ?) OR organization_id is null', true, Date.today)
    else
      Project.includes(:organization)
              .select('projects.*')
              .where('(organizations.approved = ? AND organizations.end_date > ?) OR organization_id is null', true, Date.today)
              .where('projects.title LIKE ? OR proj_desc LIKE ? OR projects.city LIKE ? OR projects.state LIKE ? or projects.zip LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%" , "%#{search}%")
    end
  end







def self.with_organizations
  joins(%q{LEFT OUTER JOIN "organizations" ON "organizations"."id" = "projects"."organization_id"})
end
=begin


#### THIS WORKS BETTER
Project.select('projects.*').joins(:sectors).joins(%q{LEFT OUTER JOIN "organizations" ON "organizations"."id" = "projects"."organization_id"}).where('sectors.id' => [6]).where('(organizations.approved = ? AND organizations.end_date > ?) OR organization_id is null', true, Date.today).group('projects.id').having('COUNT(projects.id) = ?', 1)



####  THIS WORKS
ActiveRecord::Base.connection.select_all <<-end 


SELECT projects.*  FROM "projects" INNER JOIN "projectsectors" ON "projectsectors"."project_id" = "projects"."id" INNER JOIN "sectors" ON "sectors"."id" = "projectsectors"."sector_id" LEFT OUTER JOIN "organizations" ON 
  "organizations"."id" = "projects"."organization_id" WHERE "sectors"."id" IN (6) AND ((organizations.approved = 't' 
    AND organizations.end_date > '2012-11-06') OR organization_id is null) GROUP BY projects.id HAVING COUNT(projects.id) = 1
end



SELECT "projects"."*"  FROM "projects" INNER JOIN "projectsectors" ON "projectsectors"."project_id" = "projects"."id" 
  INNER JOIN "sectors" ON "sectors"."id" = "projectsectors"."sector_id" LEFT OUTER JOIN "organizations" ON 
  "organizations"."id" = "projects"."organization_id" WHERE "sectors"."id" IN (6) AND ((organizations.approved = 't' 
    AND organizations.end_date > '2012-11-06') OR organization_id is null) GROUP BY projects.id HAVING COUNT(projects.id) = 1):

=end


  def self.search_and_filter(sector, search)
    sectorarray = sector.split(',')

    #first search results then filter them down by the sectors
    results = Project.includes(:sectors, :organization)
        .select('projects.*')
        .where('sectors.id' => sectorarray)
        .where('(organizations.approved = ? AND organizations.end_date > ?) OR organization_id is null', true, Date.today)
        .where('projects.title LIKE ? OR proj_desc LIKE ? OR projects.city LIKE ? OR projects.state LIKE ? or projects.zip LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%" , "%#{search}%")
        .group('projects.id')
        .having('COUNT(projects.id) = ?', sectorarray.size)
    return results
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

