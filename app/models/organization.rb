class Organization < ActiveRecord::Base

  has_many :organizationsectors, dependent: :destroy
  has_many :sectors, :through => :organizationsectors
  has_many :jobs, dependent: :destroy

  has_many :users, :through => :contacthistories
  has_many :contacthistories, dependent: :destroy
  
  has_many :projects, dependent: :destroy
  
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
    c = self.contacthistories.where("user_id=?", user.id)
    if c.empty?
      false
    else
      if c.first.end_date.nil? || c.first.end_date > Date.today
        true
      else
        false
      end
    end
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
               :conditions => ['approved = "true" AND UPPER(name) LIKE UPPER(?) OR UPPER(description) LIKE UPPER(?) OR UPPER(city) 
                                  LIKE UPPER(?) OR UPPER(state) LIKE UPPER(?) or UPPER(zip) LIKE UPPER(?)',
                                  "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%" , "%#{search}%"], 
              :order => 'name'
      end

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

