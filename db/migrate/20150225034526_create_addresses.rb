class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string   "street_address",    null: false
      t.string   "secondary_address"
      t.integer  "zip_code",          null: false
      t.integer  "city_id",           null: false
      t.integer  "state_id",          null: false
      t.integer  "user_id",           null: false
      t.timestamps
    end
  end
end
