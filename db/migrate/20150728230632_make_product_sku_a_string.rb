class MakeProductSkuAString < ActiveRecord::Migration
  def change
    change_column :products, :sku, :string
  end
end
