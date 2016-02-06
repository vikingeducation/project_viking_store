module AddressesHelper


  def all_states
    State.all.collect {|c| [c.name, c.id] }
  end


end
