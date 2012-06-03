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
	def self.search(search)
		if search
			find(:all, conditions: ['title LIKE ? OR proj_desc LIKE ? OR city LIKE ? OR state LIKE ? or zip LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%" , "%#{search}%"])
		else
			nil
		end
	end

	
end
