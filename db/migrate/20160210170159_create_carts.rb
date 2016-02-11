class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.integer :product_quantity
      t.integer :product_id
      t.timestamps null: false
    end
  end
end
