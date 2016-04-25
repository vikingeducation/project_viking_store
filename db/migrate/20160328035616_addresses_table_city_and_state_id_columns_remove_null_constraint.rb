class AddressesTableCityAndStateIdColumnsRemoveNullConstraint < ActiveRecord::Migration
  def change
    change_column :addresses, :city_id, :integer, :null => true
    change_column :addresses, :state_id, :integer, :null => true
  end
end
