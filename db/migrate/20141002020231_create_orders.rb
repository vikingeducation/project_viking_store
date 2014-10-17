class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|

      t.boolean :checked_out, default: true, null: false

      t.integer :userid, null: false
      t.integer :shipping_id
      t.integer :billing_id

      t.timestamps
    end
  end
end
