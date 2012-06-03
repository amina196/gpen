class CreateJobsectors < ActiveRecord::Migration
  def change
    create_table :jobsectors do |t|
      t.integer :job_id
      t.integer :sector_id
      t.timestamps
    end

    add_index :jobsectors, :job_id
    add_index :jobsectors, :sector_id
    add_index :jobsectors, [:job_id, :sector_id], unique: true
  end
end
