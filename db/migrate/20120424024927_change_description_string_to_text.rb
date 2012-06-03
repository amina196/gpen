class ChangeDescriptionStringToText < ActiveRecord::Migration
  def change
	  change_column :organizations, :description, :text
  end
end
