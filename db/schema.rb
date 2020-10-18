# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_17_172757) do

  create_table "sms_providers", force: :cascade do |t|
    t.text "url"
    t.string "redis_key_prefix"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "text_message_logs", force: :cascade do |t|
    t.string "message_id"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "text_messages", force: :cascade do |t|
    t.string "to_number"
    t.string "message"
    t.string "message_id"
    t.integer "status"
    t.integer "lock_version"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["id", "status"], name: "index_text_messages_on_id_and_status", unique: true
    t.index ["message_id"], name: "index_text_messages_on_message_id"
  end

end
