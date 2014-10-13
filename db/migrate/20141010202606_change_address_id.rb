class ChangeAddressId < ActiveRecord::Migration
  def up
    rename_column :addresses, :city, :city_id
    rename_column :addresses, :state, :state_id
  end

  def down
    rename_column :addresses, :city_id, :state
    rename_column :addresses, :state_id, :state
  end
end
