class AddDatetoOrder < ActiveRecord::Migration
  def up
    add_column :orders, :checkout_date, :datetime
  end

  def down
    remove_column :orders, :checkout_date
  end
end
