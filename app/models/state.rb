class State < ApplicationRecord

  has_many :addresses

  def self.three_with_most_users
    select("states.name AS name, COUNT(*) AS user_count").
    joins("JOIN addresses a ON states.id = a.state_id JOIN users u ON u.billing_id = a.id").
    order("user_count DESC").
    group("states.name").
    limit(3)
  end

  def self.dropdown
    all.order('name ASC')
  end

end
