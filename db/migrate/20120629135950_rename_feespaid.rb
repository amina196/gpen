class RenameFeespaid < ActiveRecord::Migration
  def change
  	rename_column :organizations, :feespaid, :approved
  end
end
