class AddColumnToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :address2, :string

  end
end
