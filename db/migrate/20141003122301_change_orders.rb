class ChangeOrders < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.remove :cart_id
      t.integer :user_id
      t.integer :billing_address_id
      t.integer :shipping_address_id
      t.boolean :is_placed, default: false
      t.datetime :placed_at

    end
  end
end
