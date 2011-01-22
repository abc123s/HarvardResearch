class AddCodeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :code, :bignum
  end

  def self.down
    remove_column :users, :code
  end
end
