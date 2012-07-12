class Jobenrollment < ActiveRecord::Base
	belongs_to :user
	belongs_to :job
	validates_uniqueness_of :user_id, :scope => :job_id

	#resume attachment using Paperclip, cf doc in Github readme
	has_attached_file :resume, 
					  :url  => "/:id/:basename.:extension",
                      :path => ":rails_root/public/:id/:basename.:extension", 
					  :storage => :s3,
    				  :bucket => ENV['S3_BUCKET_NAME'],
					  :s3_credentials => {
					     :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
					     :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
					  }
	 						  
							   


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

