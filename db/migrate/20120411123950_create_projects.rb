class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :sector_id
      t.string :proj_time
      t.string :proj_desc
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.integer :nb_people_needed
      t.string :min_age
      t.date :start_date
      t.integer :user_id

      t.timestamps
    end
  end
end
