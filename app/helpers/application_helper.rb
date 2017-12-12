module ApplicationHelper

  def bootstrap_flash_class(type)
    case type
    when 'alert' then 'warning'
    when 'error' then 'danger'
    when 'notice' then 'success'
    else
      'info'
    end
  end

  def display_error(object, field)
    object = object[-1]
    unless object.errors.empty?
      content_tag(:span, class: "error-message") do
        "#{object.errors.full_messages_for(field).first}"
      end
    end
  end

end
