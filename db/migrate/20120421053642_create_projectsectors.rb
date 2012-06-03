class CreateProjectsectors < ActiveRecord::Migration
  def change
    create_table :projectsectors do |t|
      t.integer :project_id
      t.integer :sector_id

      t.timestamps
    end
  end
end
