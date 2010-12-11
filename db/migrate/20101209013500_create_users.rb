class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.string :encrypted
      t.string :salt
      t.string :email
      t.string :phone
      t.integer :year
      t.string :concentration
      t.string :secondary
      t.float :gpa
      t.text :resume
      t.integer :privacy
      t.text :interests
      t.string :title
      t.string :location
      t.string :department
      t.integer :type

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
