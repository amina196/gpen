class Jobenrollment < ActiveRecord::Base
	belongs_to :user
	belongs_to :job
	validates_uniqueness_of :user_id, :scope => :job_id

	#resume attachment using Paperclip, cf doc in Github readme
	
end
