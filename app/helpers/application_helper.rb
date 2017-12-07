module ApplicationHelper

  def bootstrap_flash_class(type)
    case type
    when 'alert' then 'warning'
    when 'notice' then 'success'
    else
      'info'
    end
  end

  def display_error(object, field)
    unless object.errors.empty?
      "#{object.errors[field].first}"
    end
  end

end
