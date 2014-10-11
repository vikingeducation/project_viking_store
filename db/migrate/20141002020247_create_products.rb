class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|

      t.string :name, null: false
      t.integer :sku, null: false, index: true, unique: true
      t.text :description
      t.decimal :price, null: false

      t.integer :category_id

      t.timestamps
    end
  end
end
