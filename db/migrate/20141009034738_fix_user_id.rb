class FixUserId < ActiveRecord::Migration
  def up
    rename_column :orders, :userid, :user_id
  end

  def down
    rename_column :orders, :user_id, :userid
  end
end
