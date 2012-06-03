class AddCompensationToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :compensation, :string

  end
end
