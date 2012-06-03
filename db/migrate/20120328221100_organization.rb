class Organization < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string   "name"
      t.string   "description"
      t.string   "address"
      t.string   "city"
      t.string   "state"
      t.string   "zip"
      t.string   "phone"
      t.string   "website"
      t.boolean  "feespaid"
      t.date     "end_date"
      
      t.timestamps
    end
  end

end
