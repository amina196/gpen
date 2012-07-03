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

