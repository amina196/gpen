class Add < ActiveRecord::Migration
  def change
  	add_column :jobs, :start_date, :date
  end
end
