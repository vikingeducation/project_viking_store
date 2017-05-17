module AdminHelper

  def full_address(address)
    return "No address" if address.nil?
    addr = [address.street_address,
            address.secondary_address,
            address.city.name,
            address.state.name].select{ |x| !x.nil? }
    addr.join(", ")
  end

  def credit_card_options(credit_cards)
    return [] if credit_cards.blank?
    credit_cards.each_with_index.map do |cc, i|
      ["#{i+1}: Ending in #{cc.card_number[12..-1]}", cc.id]
    end
  end

end
