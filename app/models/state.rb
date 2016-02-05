class State < ActiveRecord::Base

  has_many :addresses
  

  def self.top_three_states
    State.select("s.name, COUNT(*) AS state_count")
         .joins("AS s JOIN addresses a ON s.id = a.state_id")
         .joins("JOIN users u ON u.billing_id = a.id")
         .group("s.name")
         .order("COUNT(*) DESC")
         .limit(3)
  end

  def self.top_three_users
    State.select("s.name AS state, concat(u.first_name, ' ', u.last_name) AS user , MAX(oc.quantity * p.price) AS spent")
         .joins("AS s JOIN addresses a ON s.id = a.state_id")
         .joins("JOIN users u ON u.billing_id = a.id")
         .joins("JOIN orders o ON o.user_id=u.id")
         .joins("JOIN order_contents oc ON oc.order_id=o.id")
         .joins("JOIN products p ON oc.product_id=p.id")
         .group("s.name, u.id")
         .order("spent DESC")
         .limit(3)
  end

  def self.top_state_shipped(n)
    State.select("s.name AS state, COUNT(*)")
      .joins("AS s JOIN addresses a ON s.id = a.state_id")
      .joins("JOIN users u ON u.billing_id = a.id")
      .joins("JOIN orders o ON o.user_id=u.id")
      .joins("JOIN order_contents oc ON oc.order_id=o.id")
      .joins("JOIN products p ON oc.product_id=p.id")
      .where("o.checkout_date BETWEEN (NOW() - INTERVAL '#{n} days') AND NOW()")
      .group("state")
      .maximum("COUNT(*)")
  end

end
