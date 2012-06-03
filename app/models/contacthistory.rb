class Contacthistory < ActiveRecord::Base
	belongs_to :user
	belongs_to :organization
	validates_uniqueness_of :user_id, :scope => :organization_id
	validates :start_date, :presence => true
	#validates :end_date, :presence => true
end
