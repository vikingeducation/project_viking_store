module ApplicationHelper

  def field_with_errors(object, field_sym)
    unless object.errors[field_sym].empty?
      content_tag(:div, class: "text-danger col-sm-8") do
        "#{field_sym.to_s.titleize} #{object.errors[field_sym].first}"
      end
    end
  end
end
