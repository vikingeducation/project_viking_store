class State < ApplicationRecord

  has_many :addresses
  has_many :orders, through: :addresses

  def self.top_three_states
    State.select(:name).joins(:addresses).
                       group('states.name').
                       order("count(states.name) DESC").
                       limit(3).
                       count
  end

end
