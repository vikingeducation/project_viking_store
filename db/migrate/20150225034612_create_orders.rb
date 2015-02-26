class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.boolean  "checked_out",   default: true, null: false
      t.datetime "checkout_date"
      t.integer  "user_id",                      null: false
      t.integer  "shipping_id"
      t.integer  "billing_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.timestamps
    end
  end
end
