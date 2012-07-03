class AddAttachmentResumeToJobenrollments < ActiveRecord::Migration
  def self.up
    change_table :jobenrollments do |t|
      t.has_attached_file :resume
    end
  end

  def self.down
    drop_attached_file :jobenrollments, :resume
  end
end
