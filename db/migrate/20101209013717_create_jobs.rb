class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.integer :user_id
      t.string :funding
      t.text :description
      t.string :duration
      t.string :position
      t.string :location

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
