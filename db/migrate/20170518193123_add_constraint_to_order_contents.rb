class AddConstraintToOrderContents < ActiveRecord::Migration[5.0]
  def change

    add_foreign_key :order_contents, :products
  end
end
