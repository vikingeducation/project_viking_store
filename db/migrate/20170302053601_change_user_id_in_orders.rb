class ChangeUserIdInOrders < ActiveRecord::Migration[5.0]
  def change
    change_column_null :orders, :user_id, true
  end
end
