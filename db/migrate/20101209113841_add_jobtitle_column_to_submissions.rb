class AddJobtitleColumnToSubmissions < ActiveRecord::Migration
  def self.up
    add_column :jobs, :title, :string
  end

  def self.down
    remove_column :jobs, :title
  end
end
