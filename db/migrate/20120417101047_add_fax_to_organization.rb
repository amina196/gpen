class AddFaxToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :fax, :string

  end
end
