class ChangeAddress < ActiveRecord::Migration
  def change 
  	rename_column :addresses, :city, :city_id
  	rename_column :addresses, :state, :state_id
  end
end
