class CreateOrderContents < ActiveRecord::Migration
  def change
    create_table :order_contents do |t|
      t.integer :product_id
      t.integer :order_id
      t.integer :quantity
      t.timestamps
    end
  end
end
