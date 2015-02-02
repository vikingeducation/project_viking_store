class CorrectUseridInOrder < ActiveRecord::Migration
  def change
    rename_column :orders, :userid, :user_id
  end
end
