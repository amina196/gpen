class Organizationsector < ActiveRecord::Base
	belongs_to :organization
	belongs_to :sector
	
	validates_presence_of :sector_id, :organization_id
end
