module ProductsHelper
  def field_error_message(resource, sym)
    unless resource.errors[sym].empty?
      content_tag(:li, class: "error-message") do
         sym.to_s.titleize + " " + resource.errors[sym].first
      end
    end
  end
end
