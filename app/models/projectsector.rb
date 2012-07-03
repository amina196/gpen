class Projectsector < ActiveRecord::Base

belongs_to :project
belongs_to :sector

end
# == Schema Information
#
# Table name: projectsectors
#
#  id         :integer         not null, primary key
#  project_id :integer
#  sector_id  :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

