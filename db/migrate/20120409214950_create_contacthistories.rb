class CreateContacthistories < ActiveRecord::Migration
  def change
    create_table :contacthistories do |t|
      t.integer :user_id
      t.integer :organization_id
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
