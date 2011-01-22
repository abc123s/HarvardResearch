# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110122190420) do

  create_table "jobs", :force => true do |t|
    t.integer   "user_id"
    t.string    "funding"
    t.text      "description"
    t.string    "duration"
    t.string    "position"
    t.string    "location"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "title"
    t.datetime  "deadline"
  end

  create_table "submissions", :force => true do |t|
    t.integer   "job_id"
    t.integer   "user_id"
    t.text      "coverletter"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

# Could not dump table "users" because of following StandardError
#   Unknown type 'bignum' for column 'code'

end
