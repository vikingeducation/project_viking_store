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

ActiveRecord::Schema.define(version: 20141010224012) do

  create_table "addresses", force: true do |t|
    t.string   "street_address",    null: false
    t.string   "secondary_address"
    t.integer  "zip_code",          null: false
    t.integer  "city_id",           null: false
    t.integer  "state_id",          null: false
    t.integer  "user_id",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number"
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

  create_table "orders", force: true do |t|
    t.boolean  "checked_out",   default: true, null: false
    t.integer  "user_id",                      null: false
    t.integer  "shipping_id"
    t.integer  "billing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "checkout_date"
  end

  create_table "products", force: true do |t|
    t.string   "name",                                null: false
    t.decimal  "sku",                                 null: false
    t.text     "description"
    t.decimal  "price",       precision: 8, scale: 2, null: false
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchases", force: true do |t|
    t.integer  "order_id",               null: false
    t.integer  "product_id",             null: false
    t.integer  "quantity",   default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name",  null: false
    t.string   "last_name",   null: false
    t.string   "email",       null: false
    t.integer  "billing_id"
    t.integer  "shipping_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
