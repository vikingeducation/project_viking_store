class ChangeAddress < ActiveRecord::Migration
  def change
    change_table :addresses do |t|
      t.remove :street1, :city1, :state1, :zip1, :default_address1
      t.remove :street2, :city2, :state2, :zip2, :default_address2
      t.remove :street3, :city3, :state3, :zip3, :default_address3
      t.remove :street4, :city4, :state4, :zip4, :default_address4
      t.remove :street5, :city5, :state5, :zip5, :default_address5
      
      t.string :street_address
      t.string :city
      t.string :state
      t.integer :zip
      t.boolean :is_active, default: true


    end
  end
end
 