class BurnCheckedOutWithFire < ActiveRecord::Migration
  def up
    remove_column :orders, :checked_out
  end

  def down
    add_column :orders, :checked_out, :boolean, :null => false
  end
end
