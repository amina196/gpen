class AddShortdescriptionToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :shortdescription, :string

  end
end
