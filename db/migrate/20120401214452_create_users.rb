class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :fname
      t.string :lname
      t.date :birth_date
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
