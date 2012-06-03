class AddSectorToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :sector_id, :integer

  end
end
