class Jobsector < ActiveRecord::Base
	belongs_to :sector
	belongs_to :job
end
