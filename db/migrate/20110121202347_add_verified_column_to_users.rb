class AddVerifiedColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :verified, :integer
  end

  def self.down
    remove_column :users, :verified
  end
end
