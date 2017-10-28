module ProductsHelper

  def display_product_form_errors(resource, field)
    unless resource.errors[field].empty?
      content_tag(:span, class: "error-msg") do
        "#{field.to_s.titleize} #{resource.errors[field].first}"
      end
    end
  end

end
