class RenameTypeColumn < ActiveRecord::Migration
  def self.up
    rename_column :users, :type, :usertype
  end

  def self.down
    rename_column :users, :usertype, :type
  end
end
