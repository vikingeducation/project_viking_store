class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :user_id

      t.string  :street1
      t.string  :city1
      t.string  :state1
      t.integer :zip1
      t.boolean :default_address1, default: false

      t.string  :street2
      t.string  :city2
      t.string  :state2
      t.integer :zip2
      t.boolean :default_address2, default: false

      t.string  :street3
      t.string  :city3
      t.string  :state3
      t.integer :zip3
      t.boolean :default_address3, default: false

      t.string  :street4
      t.string  :city4
      t.string  :state4
      t.integer :zip4
      t.boolean :default_address4, default: false

      t.string  :street5
      t.string  :city5
      t.string  :state5
      t.integer :zip5
      t.boolean :default_address5, default: false

      t.timestamps
    end
  end
end
