class AddColumnsToOrganizationsectors < ActiveRecord::Migration
  def change
  	add_column :organizationsectors, :sector_id, :integer
  	add_column :organizationsectors, :organization_id, :integer
  end
end
