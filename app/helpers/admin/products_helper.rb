module Admin::ProductsHelper

  def display_product_form_errors(resource, field)
    unless resource.errors[field].empty?
      content_tag(:span, class: "error-msg") do
        "#{field.to_s.titleize} #{resource.errors[field].first}"
      end
    end
  end


  def display_category_name(cat_id)
    Category.find(cat_id).name
  end


end
