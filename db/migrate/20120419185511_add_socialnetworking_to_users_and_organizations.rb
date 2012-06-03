class AddSocialnetworkingToUsersAndOrganizations < ActiveRecord::Migration
  def change
  	add_column :users, :facebook, :string
  	add_column :users, :twitter, :string
  	add_column :users, :linkedin, :string
  	add_column :organizations, :facebook, :string
  	add_column :organizations, :twitter, :string
  	add_column :organizations, :linkedin, :string
  end
end
