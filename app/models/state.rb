class State < ApplicationRecord

  has_many :addresses
  has_many :orders, through: :addresses

  def self.top_three_states
    State.select(:name).joins_addresses_onto_states.
                       joins_orders_onto_addresses.
                       group('states.name').
                       order("count(states.name) DESC").
                       limit(3).
                       count
  end


  private


    def self.joins_addresses_onto_states
      joins('JOIN addresses ON states.id = addresses.state_id')
    end

    def self.joins_orders_onto_addresses
      joins('JOIN orders ON orders.billing_id = addresses.id')
    end




end
