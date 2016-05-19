module ProductsHelper
  
  def message_errors(resource, field)
    if resource.errors[field].empty?
      error = ""
    else
      error = content_tag(:div, class: "error") do
        field.to_s.titleize + " " + resource.errors[field].first
      end
    end
  end

  def product_quantity(order, product)
    OrderContent.where(:order_id => order.id).where(:product_id => product.id).first.quantity
  end
end
