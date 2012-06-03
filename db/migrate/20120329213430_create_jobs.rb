class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :description
      t.string :status
      t.string :availability
      t.belongs_to :organization

      t.timestamps
    end
    add_index :jobs, :organization_id
  end
end
