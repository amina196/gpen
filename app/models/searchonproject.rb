class Searchonproject < ActiveRecord::Base

	def projects
		@projects ||= find_searchedprojects 
	end

	def find_searchedprojects
		Project.find(:all, conditions: conditions)
	end

	def city_conditions
		["city LIKE ?", "%#{city}%"] unless city.blank?
	end

	def zip_conditions
		["zip LIKE ?", "%#{zip}%"] unless zip.blank?
	end

	def state_conditions
		["state LIKE ?", "%#{state}%"] unless state.blank?
	end

	def title_conditions
		["title LIKE ?", "%#{title}%"] unless title.blank?
	end

	#builder of the SQL query
	def conditions
		[conditions_clauses.join(' AND '), *conditions_options]
	end
	
	def conditions_clauses
		conditions_parts.map { |condition| condition.first} 
	end
	
	def conditions_options
		conditions_parts.map { |condition| condition[1..-1] }.flatten 
	end
	
	def conditions_parts
		methods.grep(/_conditions$/).map{ |m| send(m)}.compact
	end

end
# == Schema Information
#
# Table name: searchonprojects
#
#  id         :integer         not null, primary key
#  city       :string(255)
#  state      :string(255)
#  zip        :string(255)
#  title      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

