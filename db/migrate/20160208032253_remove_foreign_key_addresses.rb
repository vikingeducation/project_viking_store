class RemoveForeignKeyAddresses < ActiveRecord::Migration
  def change
    remove_column :users, :addresses_id
  end
end
