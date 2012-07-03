class Projectenrollment < ActiveRecord::Base
	belongs_to :project
	belongs_to :user

	validates :user_id, presence: true
	validates :project_id, presence: true
end
# == Schema Information
#
# Table name: projectenrollments
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  project_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

