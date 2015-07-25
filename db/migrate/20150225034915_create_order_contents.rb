class CreateOrderContents < ActiveRecord::Migration
  def change
    create_table :order_contents do |t|
      t.integer  "order_id",               null: false
      t.integer  "product_id",             null: false
      t.integer  "quantity",   default: 1, null: false
      t.timestamps
    end
    add_index :order_contents, [:order_id, :product_id], unique: true
  end
end
