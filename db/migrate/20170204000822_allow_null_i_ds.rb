class AllowNullIDs < ActiveRecord::Migration[5.0]
  def change
  		change_column :addresses, :city_id, :integer, :null => true
  		change_column :addresses, :state_id, :integer, :null => true
  		change_column :addresses, :user_id, :integer, :null => true

  		change_column :credit_cards, :user_id, :integer, :null => true
  		change_column :orders, :user_id, :integer, :null => true
  end
end
