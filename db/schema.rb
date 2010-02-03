# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100201192730) do

  create_table "assets", :force => true do |t|
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.string   "data_file_size"
    t.string   "data_updated_at"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.text     "description"
    t.integer  "company_id"
    t.string   "model"
    t.string   "color"
    t.date     "bought_on"
    t.string   "price"
    t.string   "permalink"
    t.string   "owner_name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "city"
    t.string   "state"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
