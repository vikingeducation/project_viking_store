# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150228223038) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.string   "street_address",    null: false
    t.string   "secondary_address"
    t.integer  "zip_code",          null: false
    t.integer  "city_id",           null: false
    t.integer  "state_id",          null: false
    t.integer  "user_id",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name",        null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["name"], name: "index_cities_on_name", unique: true, using: :btree

  create_table "credit_cards", force: true do |t|
    t.string   "nickname",    default: "My Credit Card"
    t.integer  "card_number",                            null: false
    t.integer  "exp_month",                              null: false
    t.integer  "exp_year",                               null: false
    t.string   "brand",       default: "VISA",           null: false
    t.integer  "user_id",                                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "credit_cards", ["card_number"], name: "index_credit_cards_on_card_number", unique: true, using: :btree

  create_table "order_contents", force: true do |t|
    t.integer  "order_id",               null: false
    t.integer  "product_id",             null: false
    t.integer  "quantity",   default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_contents", ["order_id", "product_id"], name: "index_order_contents_on_order_id_and_product_id", unique: true, using: :btree

  create_table "orders", force: true do |t|
    t.datetime "checkout_date"
    t.integer  "user_id",       null: false
    t.integer  "shipping_id"
    t.integer  "billing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.string   "name",                                null: false
    t.decimal  "sku",                                 null: false
    t.text     "description"
    t.decimal  "price",       precision: 8, scale: 2, null: false
    t.integer  "category_id",                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["name"], name: "index_products_on_name", using: :btree
  add_index "products", ["sku"], name: "index_products_on_sku", unique: true, using: :btree

  create_table "states", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "states", ["name"], name: "index_states_on_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name",  null: false
    t.string   "last_name",   null: false
    t.string   "email",       null: false
    t.integer  "billing_id"
    t.integer  "shipping_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
