class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|

      t.string :name, null: false, index: true, unique: true
      t.text :description

      t.timestamps
    end
  end
end
