class RemoveNullConstraintFromProductCategoryId < ActiveRecord::Migration
  def change
    change_column_null(:products, :category_id, true)
  end
end
