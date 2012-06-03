class AddBioToUser < ActiveRecord::Migration
  def change
  	add_column :users, :bio, :string, :limit => 1000
  end
end
