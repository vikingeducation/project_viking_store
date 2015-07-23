module UsersHelper

  def render_user_addresses(f, available_addresses, field_sym)
    if available_addresses.empty?
      "N/A"
    else
      f.collection_select field_sym, available_addresses, :id, :id_and_address
    end
  end


end
