class Jobenrollment < ActiveRecord::Base
	belongs_to :user
	belongs_to :job
	validates_uniqueness_of :user_id, :scope => :job_id

	#resume attachment using Paperclip, cf doc in Github readme
	has_attached_file :resume, url: "/resumes/:id/:basename.:extension",
							   path: ":rails_root/public/resumes/:id/:basename.:extension"

	#validates_attachment_presence :resume
end
# == Schema Information
#
# Table name: jobenrollments
#
#  id                  :integer         not null, primary key
#  user_id             :integer
#  job_id              :integer
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#  resume_file_name    :string(255)
#  resume_content_type :string(255)
#  resume_file_size    :integer
#  resume_updated_at   :datetime
#

