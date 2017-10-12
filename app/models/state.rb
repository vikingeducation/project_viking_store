class State < ApplicationRecord

  def top_three_states
    State.select(:name).join_addresses_onto_states
                       .join_orders_onto_addresses
                       .group_top_three('states.name')
  end


  private


  def join_addresses_onto_states
    joins('JOIN addresses ON states.id = addresses.state_id')
  end

end
