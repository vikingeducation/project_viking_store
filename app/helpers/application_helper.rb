module ApplicationHelper
  def field_with_errors(object, field)
    if object.errors[field].empty?
      errors = ""
    else
      errors = field.to_s.titleize + " " + object.errors[field].first
      content_tag(:div, errors, class: "error_message")
    end
  end
end
