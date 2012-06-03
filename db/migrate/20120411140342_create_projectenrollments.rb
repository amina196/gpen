class CreateProjectenrollments < ActiveRecord::Migration
  def change
    create_table :projectenrollments do |t|
      t.integer :user_id
      t.integer :project_id

      t.timestamps
   end
   
    add_index :projectenrollments, [:user_id, :project_id], unique: true
  end
end
