class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|

      t.string :street_address, null: false
      t.string :secondary_address
      t.integer :zip_code, null: false

      #id for these relationships
      t.integer :city, null: false
      t.integer :state, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
