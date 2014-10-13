class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|

      t.integer :order_id, null: false
      t.integer :product_id, null: false
      t.integer :quantity, null: false, default: 1

      t.timestamps
    end
  end
end
