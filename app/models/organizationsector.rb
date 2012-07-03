class Organizationsector < ActiveRecord::Base
	belongs_to :organization
	belongs_to :sector
	
	validates_presence_of :sector_id, :organization_id
end
# == Schema Information
#
# Table name: organizationsectors
#
#  id              :integer         not null, primary key
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  sector_id       :integer
#  organization_id :integer
#

