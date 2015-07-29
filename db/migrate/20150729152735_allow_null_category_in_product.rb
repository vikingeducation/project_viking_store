class AllowNullCategoryInProduct < ActiveRecord::Migration
  def change
    change_column :products, :category_id, :integer, :null => true
  end
end
