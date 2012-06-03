class RemoveColumnFromSearchonproject < ActiveRecord::Migration
  def change
    remove_column :searchonprojects, :new
    remove_column :searchonprojects, :show
      end

end
