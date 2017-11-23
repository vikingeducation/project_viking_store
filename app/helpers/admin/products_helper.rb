module Admin::ProductsHelper

  def display_category_name(cat_id)
    Category.find(cat_id).name
  end


end
