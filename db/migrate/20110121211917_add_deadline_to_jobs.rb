class AddDeadlineToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :deadline, :datetime
  end

  def self.down
    remove_column :jobs, :deadline
  end
end
