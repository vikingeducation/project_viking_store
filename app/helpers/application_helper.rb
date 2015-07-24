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


  def render_user_addresses(f, available_addresses, field_sym)
    if available_addresses.empty?
      "N/A"
    else
      f.collection_select field_sym, available_addresses, :id, :id_and_address
    end
  end


  def render_user_cards(f, available_cards, field_sym)
    if available_cards.empty?
      "N/A"
    else
      f.collection_select field_sym, available_cards, :id, :id_and_address
    end
  end


end
