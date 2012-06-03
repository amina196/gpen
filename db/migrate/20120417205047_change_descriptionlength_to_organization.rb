class ChangeDescriptionlengthToOrganization < ActiveRecord::Migration
  def change
  	change_column :organizations, :description, :string, :limit => 1000
  	change_column :organizations, :shortdescription, :string, :limit => 1000
  end
end
