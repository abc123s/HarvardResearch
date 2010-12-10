class CreateSubmissions < ActiveRecord::Migration
  def self.up
    create_table :submissions do |t|
      t.integer :job_id
      t.integer :user_id
      t.text :coverletter

      t.timestamps
    end
  end

  def self.down
    drop_table :submissions
  end
end
