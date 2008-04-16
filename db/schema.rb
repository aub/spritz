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

ActiveRecord::Schema.define(:version => 8) do

  create_table "assets", :force => true do |t|
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
    t.integer  "site_id"
    t.integer  "thumbnails_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cache_items", :force => true do |t|
    t.integer  "site_id"
    t.text     "references"
    t.string   "type"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.integer  "section_id"
    t.string   "url"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", :force => true do |t|
    t.integer  "site_id"
    t.boolean  "active"
    t.integer  "position",   :default => 1
    t.text     "options"
    t.string   "type"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites", :force => true do |t|
    t.string   "subdomain"
    t.string   "domain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "settings"
  end

  add_index "sites", ["domain", "subdomain"], :name => "index_sites_on_domain_and_subdomain"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                   :default => "passive"
    t.datetime "deleted_at"
    t.boolean  "admin",                                   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
