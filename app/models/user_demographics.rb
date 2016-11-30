class UserDemographics

  def self.location_demo(location)
    locations = User.count_by_demo(location, limit: 3)
    locations.map do |row|
      [ row.name, row.user_count ]
    end
  end

  def self.extremist_users
      [
        greatest_revenue(type: 'Single'),
        greatest_revenue,
        greatest_revenue(type: 'Average', aggr:'AVG'),
        most_orders
      ]
  end

  def self.greatest_revenue(type: "Lifetime", aggr: "SUM")
    user = User.greatest_revenue(type: type, aggr: aggr)

    ["Highest #{type} Order Value", user.name, ActionController::Base.helpers.number_to_currency(user.quantity)]
  end

  def self.most_orders
    user = User.most_orders

    ["Most Orders Placed", user.name, user.quantity]           
  end


end
