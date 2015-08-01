module ApplicationHelper
  def bootstrap_class_for(flash_type)
    case flash_type.to_sym
    when :success
      "alert-success"
    when :danger
      "alert-danger"
    when :error
      "alert-danger"
    when :alert
      "alert-warning"
    when :notice
      "alert-info"
    else
      flash_type.to_s
    end
  end

  def field_with_errors(object,field)

    # No errors if no errors!
    if object.errors[field].empty?
      error = ""
    else
      # Otherwise, create an error <div> around the message
      error = content_tag(:div, :class=>"error") do
        field.to_s.titleize + " " + object.errors[field].first
      end
    end
  end

end
