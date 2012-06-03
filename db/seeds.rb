# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


require 'csv'
CSV.foreach('./db/GPEN_Organizations.csv', headers: true) do |row|
	record = Organization.create(name: row['name'], address: row['Address1'], address2: row['Address2'], city: row['city'], state: row['state'], zip: row['zip'], phone: row['phone'], fax: row['fax'], website: row['website'])
	#Description is longer description if it exists, otherwise, use short description
	if !row['longdescription'].nil?
		record.description = row['longdescripton']
	else
		record.description = row['shortdescription']
	end

	if !record.valid? 
		p record
		p record.errors.full_messages
	end
	record.save
end

CSV.foreach('./db/GPEN_User.csv', headers: true) do |row|
	record = User.new(fname: row['FirstName'], lname: row['LastName'], phone: row['Phone'], email: row['E-mail'], password: 'temppassword', password_confirmation: 'temppassword')
	if !record.valid? 
		p record
		p record.errors.full_messages
	end
	record.save
end

CSV.foreach('./db/GPEN_Sector.csv', headers: true) do |row|
	record = Sector.new(description: row['Sector'])
	if !record.valid? 
		p record
		p record.errors.full_messages
	end
	record.save
end

CSV.foreach('./db/GPEN_OrganizationSectors.csv', headers: true) do |row|
	record = Organizationsector.new(organization_id: row['orgid'], sector_id: row['sectorid'])
	if !record.valid? 
		p record
		p record.errors.full_messages
	end
	record.save
end
CSV.foreach('./db/GPEN_ContactHistory.csv', headers: true) do |row|
	record = Contacthistory.new(organization_id: row['orgid'], start_date: "2012-04-24")
	
	if !User.find_by_email(row['email']).nil?
		record.user_id = User.find_by_email(row['email']).id
	end

	if !record.valid? 
		p record
		p record.errors.full_messages
	end
	record.save
end