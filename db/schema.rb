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

ActiveRecord::Schema.define(:version => 20110121211917) do

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

  create_table "users", :force => true do |t|
    t.string    "firstname"
    t.string    "lastname"
    t.string    "encrypted"
    t.string    "salt"
    t.string    "email"
    t.string    "phone"
    t.integer   "year"
    t.string    "concentration"
    t.string    "secondary"
    t.float     "gpa"
    t.text      "resume"
    t.integer   "privacy"
    t.text      "interests"
    t.string    "title"
    t.string    "location"
    t.string    "department"
    t.integer   "usertype"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "verified"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
