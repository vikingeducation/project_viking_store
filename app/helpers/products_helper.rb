module ProductsHelper

  def category_link(product)
    if product.category
      link_to(product.category.name, product.category)
    else
      "(deleted)"
    end
  end

end
