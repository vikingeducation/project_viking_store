class ProductSkuNotRequired < ActiveRecord::Migration[5.0]
  def change
    change_column_null(:products, :sku, true)
  end
end
