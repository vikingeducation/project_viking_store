class ChangeUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :default_billing_address_id
      t.integer :default_shipping_address_id

    end

  end
end
