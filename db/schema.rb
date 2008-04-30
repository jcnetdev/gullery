# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 2) do

  create_table "assets", :force => true do |t|
    t.integer  "project_id"
    t.string   "path"
    t.string   "caption"
    t.string   "type",       :limit => 40
    t.boolean  "is_visible",               :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "projects", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.boolean  "is_visible",  :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.text     "description"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "sessions_session_id_index"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "tags_assets", :id => false, :force => true do |t|
    t.integer "tag_id"
    t.integer "asset_id"
  end

  create_table "tags_projects", :id => false, :force => true do |t|
    t.integer "tag_id"
    t.integer "project_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name",             :limit => 100
    t.string   "company",          :limit => 100
    t.string   "website"
    t.string   "login",            :limit => 40
    t.string   "email",            :limit => 100
    t.string   "crypted_password", :limit => 40
    t.string   "salt",             :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

end
