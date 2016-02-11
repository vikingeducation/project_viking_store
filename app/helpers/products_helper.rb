module ProductsHelper

  def category_name(product)
    Category.where(:id => product.category_id).first.name
  end


  def category_id(product)
    Category.where(:id => product.category_id).first.id
  end


end
