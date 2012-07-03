class Jobsector < ActiveRecord::Base
	belongs_to :sector
	belongs_to :job
end
# == Schema Information
#
# Table name: jobsectors
#
#  id         :integer         not null, primary key
#  job_id     :integer
#  sector_id  :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

