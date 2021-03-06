class Organization < ActiveRecord::Base
    require 'will_paginate/array'
    #### ASSOCIATION ####

 #one-to-many rel Job
  has_many :jobs, dependent: :destroy

 #one-to-many rel with Project
  has_many :projects, dependent: :destroy

 #many-to-many rel with Sector
  has_many :organizationsectors, dependent: :destroy
  has_many :sectors, :through => :organizationsectors

 #many-to-many rel with User (as admin)
  has_many :users, :through => :contacthistories
  has_many :contacthistories, dependent: :destroy
  
  
     #### VALIDATION ####

  validates :name, :presence => true
  
  valid_email_regex = /(^$)|\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: valid_email_regex }

#autre website regex : /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/ 
  valid_website_regex = /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix
  validates :website, format: { with: valid_website_regex }
  validates :email, :presence => true
  validates :address, :presence => true
  validates :city, :presence => true
  validates :state, :presence => true
  validates :zip, :presence => true
  validates :phone, :presence => true
  validates :description, :presence => true
  #validates :address2, :presence => true


  def current_admin?(user)
    user.current_organizations.include?(self)
  end

  def renew(months)
    # always renew from today's date, rather than from the current end_date
    self.end_date = Date.today + months.to_i.months

    # make sure the organization has been approved
    self.approved = true
  end

  def changeadmin(user_id, end_date)
    
  end

  #def self.search(search, page, sector)


     #sector : string of the form 'id1,id2,id3...'   
=begin      
      paginate :per_page => 10, 
               :page => page,
               :conditions => ['approved = ? AND end_date > ? AND (UPPER(name) LIKE UPPER(?) OR UPPER(description) LIKE UPPER(?) OR UPPER(city) LIKE UPPER(?) OR UPPER(state) LIKE UPPER(?) or UPPER(zip) LIKE UPPER(?))', true, Date.today,"%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%" , "%#{search}%"], 
                :order => 'name'
      end
=end


  def self.filter(sector)
        sectorarray = sector.split(',')
        #a = Organizationsector.find_all_by_sector_id(sectorarray)
        #b = a.collect {|orgsec| orgsec.organization}
        #return b

        return Organization.joins(:sectors)
                          .where('sectors.id' => sectorarray)
                          .group('organizations.id')
                          .where('approved = ? AND end_date > ?', true, Date.today) # get only orgs that have been approved and have not expired
                          .having('COUNT(organizations.id) = ?', sectorarray.size)

  end

  def self.search(search)
    if search.empty?
      Organization.where('approved = ? AND end_date > ?', true, Date.today) # get only orgs that have been approved and have not expired
    else
      Organization.find(:all, :conditions => ['approved = ? AND end_date > ? AND (UPPER(name) LIKE UPPER(?) OR UPPER(description) LIKE UPPER(?) OR UPPER(city) LIKE UPPER(?) OR UPPER(state) LIKE UPPER(?) or UPPER(zip) LIKE UPPER(?))', true, Date.today,"%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%" , "%#{search}%"])
    end
  end

  def self.search_and_filter(sector, search)
    sectorarray = sector.split(',')

    #first search results then filter them down by the sectors
    results = Organization.joins(:sectors)
                .where('sectors.id' => sectorarray)
                .where('approved = ? AND end_date > ?',  true, Date.today) # get only orgs that have been approved and have not expired
                .where('UPPER(name) LIKE UPPER(?) OR UPPER(organizations.description) LIKE UPPER(?) OR UPPER(city) LIKE UPPER(?) OR UPPER(state) LIKE UPPER(?) or UPPER(zip) LIKE UPPER(?)', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
                .group('organizations.id')
                .having('COUNT(organizations.id) = ?', sectorarray.size)

    return results

    # Amina's old filtering code, which finds UNION of filters, not INTERSECTION
    # searchresult.each do |o|
    #   sector_ids = o.sectors.collect {|sector| sector.id.to_s}
    #   sector_ids.each do |s| 
    #     if sectors.include?(s) 
    #       result = result << o
    #       break
    #     end
    #   end
    # end
    # return result

  end



STATES = [
    ['Alabama', 'AL'],
    ['Alaska', 'AK'],
    ['Arizona', 'AZ'],
    ['Arkansas', 'AR'],
    ['California', 'CA'],
    ['Colorado', 'CO'],
    ['Connecticut', 'CT'],
    ['Delaware', 'DE'],
    ['District of Columbia', 'DC'],
    ['Florida', 'FL'],
    ['Georgia', 'GA'],
    ['Hawaii', 'HI'],
    ['Idaho', 'ID'],
    ['Illinois', 'IL'],
    ['Indiana', 'IN'],
    ['Iowa', 'IA'],
    ['Kansas', 'KS'],
    ['Kentucky', 'KY'],
    ['Louisiana', 'LA'],
    ['Maine', 'ME'],
    ['Maryland', 'MD'],
    ['Massachusetts', 'MA'],
    ['Michigan', 'MI'],
    ['Minnesota', 'MN'],
    ['Mississippi', 'MS'],
    ['Missouri', 'MO'],
    ['Montana', 'MT'],
    ['Nebraska', 'NE'],
    ['Nevada', 'NV'],
    ['New Hampshire', 'NH'],
    ['New Jersey', 'NJ'],
    ['New Mexico', 'NM'],
    ['New York', 'NY'],
    ['North Carolina', 'NC'],
    ['North Dakota', 'ND'],
    ['Ohio', 'OH'],
    ['Oklahoma', 'OK'],
    ['Oregon', 'OR'],
    ['Pennsylvania', 'PA'],
    ['Puerto Rico', 'PR'],
    ['Rhode Island', 'RI'],
    ['South Carolina', 'SC'],
    ['South Dakota', 'SD'],
    ['Tennessee', 'TN'],
    ['Texas', 'TX'],
    ['Utah', 'UT'],
    ['Vermont', 'VT'],
    ['Virginia', 'VA'],
    ['Washington', 'WA'],
    ['West Virginia', 'WV'],
    ['Wisconsin', 'WI'],
    ['Wyoming', 'WY']
  ]
end

# == Schema Information
#
# Table name: organizations
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :text(1000)
#  address     :string(255)
#  city        :string(255)
#  state       :string(255)
#  zip         :string(255)
#  phone       :string(255)
#  website     :string(255)
#  feespaid    :boolean
#  end_date    :date
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  address2    :string(255)
#  fax         :string(255)
#  facebook    :string(255)
#  twitter     :string(255)
#  linkedin    :string(255)
#  email       :string(255)
#

