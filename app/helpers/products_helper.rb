module ProductsHelper

  def category_link(product)
    if product.category
      link_to(product.category.name, product.category)
    else
      "(deleted)"
    end
  end

  def product_submit(form_builder, product)
    submit_string = product.id ? "Update Product" : "Create Product"
    form_builder.submit(submit_string, class: "btn btn-primary btn-lg btn-block btn-create")
  end

  def price_field(product)
    product.price ? "$#{product.price}": ""
  end

end
