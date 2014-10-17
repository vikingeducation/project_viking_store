class RemoveNullFromUserIdInOrders < ActiveRecord::Migration
  def change
    change_column :orders, :user_id, :integer, :null => true
  end
end
