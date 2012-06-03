class CreateOrganizationsectors < ActiveRecord::Migration
  def change
    create_table :organizationsectors do |t|

      t.timestamps
    end
  end
end
