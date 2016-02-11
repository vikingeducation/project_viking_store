module AddressesHelper


  def all_states
    State.all.collect {|c| [c.name, c.id] }
  end

  def num_orders(address)
    address.user.orders.where("shipping_id = #{address.id}").count
  end



end
