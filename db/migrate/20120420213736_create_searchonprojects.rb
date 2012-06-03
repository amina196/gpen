class CreateSearchonprojects < ActiveRecord::Migration
  def change
    create_table :searchonprojects do |t|
      t.string :city
      t.string :state
      t.string :zip
      t.string :title
      t.string :new
      t.string :show

      t.timestamps
    end
  end
end
