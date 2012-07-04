class Contacthistory < ActiveRecord::Base
	belongs_to :user
	belongs_to :organization
	validates_uniqueness_of :user_id, :scope => :organization_id
	#validates :start_date, :presence => true
	#validates :end_date, :presence => true

	def current?
		!start_date.nil? && (end_date.nil? || end_date > Date.today)
	end

end
# == Schema Information
#
# Table name: contacthistories
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  organization_id :integer
#  start_date      :date
#  end_date        :date
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

