module ApplicationHelper

  def render_error(resource, field_sym=nil)
    "#{field_sym.to_s.titleize} #{resource.errors[field_sym].first}" unless resource.errors[field_sym].empty?
  end


  def color_status_text(status)
    if status == 'UNPLACED'
      "class=text-danger"
    else
      "class=text-success"
    end
  end


end
