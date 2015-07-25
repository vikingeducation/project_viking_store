class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string   "name",                                null: false
      t.decimal  "sku",                                 null: false
      t.text     "description"
      t.decimal  "price",       precision: 8, scale: 2, null: false
      t.integer  "category_id",                         null: false
      t.timestamps

    end
    add_index :products, :sku, unique: true

    # not 100% sure it's unique, so leave it off
    add_index :products, :name
  end
end
