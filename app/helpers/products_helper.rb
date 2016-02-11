module ProductsHelper

  def category_filter(category)
    if category.nil? || category['category_id'] == ""
      Product.all
    else
      Product.all.where("category_id = #{category['category_id']}" )
    end
  end

  def category_name(category)
    if category.nil? || category['category_id'].empty?
      "All"
    else
      "#{Category.find(category['category_id']).name}"
    end
  end

end
