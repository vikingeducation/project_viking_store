class ChangeSkuTypetoDecimal < ActiveRecord::Migration
  def up
    change_column :products, :sku, :decimal
  end

  def down
    change_column :products, :price, :integer
  end

end
