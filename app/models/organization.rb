class Organization < ActiveRecord::Base
    
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

  valid_website_regex = /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix
  validates :website, format: { with: valid_website_regex }
  #validates :address, :presence => true
  #validates :city, :presence => true
  #validates :state, :presence => true
  #validates :zip, :presence => true
  #validates :phone, :presence => true
  #validates :address2, :presence => true


  def current_admin?(user)
    user.current_organizations.include?(self)
  end

  def renew(months)
    self.end_date = self.end_date + months.to_i.months
  end

=begin
  def self.search(search)
    if search
      find(:all, conditions: ['UPPER(name) LIKE UPPER(?) OR UPPER(description) LIKE UPPER(?) OR UPPER(city) 
                              LIKE UPPER(?) OR UPPER(state) LIKE UPPER(?) or UPPER(zip) LIKE UPPER(?)',
                              "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%" , "%#{search}%"])
    else
      find(:all).paginate(:page => params[:page], :per_page => 10)
    end
  end
=end

  def self.search(search, page, sector, id)
      #sectors = self.sectors   #array of the sectors of the organization 
      paginate :per_page => 10, 
               :page => page,
               :conditions => ['approved = ? AND end_date > ? AND (UPPER(name) LIKE UPPER(?) OR UPPER(description) LIKE UPPER(?) OR UPPER(city) 
                                  LIKE UPPER(?) OR UPPER(state) LIKE UPPER(?) or UPPER(zip) LIKE UPPER(?))', true, Date.today,
                                  "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%" , "%#{search}%"], 
              :order => 'name'
      end

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

