class RemoveUnecessaryFields < ActiveRecord::Migration
  def change
  	remove_column :organizations, :sector_id
  	remove_column :organizations, :shortdescription
  	remove_column :projects, :sector_id
  	#remove_column :jobs, :sector_id
  end
end
