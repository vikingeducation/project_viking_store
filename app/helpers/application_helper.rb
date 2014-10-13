module ApplicationHelper
  def submit(form_type, object)
    "#{(form_type == "Edit" ? "Update" : form_type)} #{object}"
  end

  def index_title(user, objects)
    if user
      "#{user.name}'s #{objects.capitalize}"
    else
      objects.capitalize
    end
  end

  def display_if(object)
    object.present? ? object : "N/A"
  end
end
