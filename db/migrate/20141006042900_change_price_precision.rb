class ChangePricePrecision < ActiveRecord::Migration

  def up
    change_column :products, :price, :decimal, precision: 5, scale: 2
  end

  def down
    change_column :products, :price, :decimal, precision: 3, scale: 2
  end

end
