module  AdminHelper
  def nav_link(link_text, link_path, options = {})

    # Determine if link is to active page (sets gray background)
    class_name = link_path.include?(controller_name) ? 'active' : nil

    # Add a badge to the link, and extra classes to the li
    if options[:badge]
      badge = " <span class='badge'>#{options[:badge]}</span>"
      link_text += " #{badge}"
    elsif options[:class]
      class_name = "#{class_name} #{options[:class]}"
    end  
     
    # Generate  link  
    link_to(link_path, class: class_name) do
      link_text.html_safe
    end

  end
end