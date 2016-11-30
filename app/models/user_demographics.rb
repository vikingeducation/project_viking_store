class UserDemographics

  def self.location_demo(location)

    locations = User.count_by_demo(location, limit: 3)

    locations.map do |row|
      [ row.name, row.user_count ]
    end

  end

  def self.extremist_users
    # User with... [ item, name, quantity ]
      # most revenue in single order
      # most revenue generated over lifetime
      # highest average revenue per order
      # most orders placed
      [
        greatest_revenue(type: 'Single'),
        greatest_revenue,
        greatest_revenue(type: 'Average', aggr:'AVG'),
        most_orders
      ]
  end
  def self.greatest_revenue(type: "Lifetime", aggr: "SUM")
    user =  User.select("CONCAT(first_name,' ',last_name) as name, #{aggr}(quantity * price) as quantity")
                .joins("JOIN orders ON (user_id = users.id)")
                .joins("JOIN order_contents ON (order_id = orders.id)")
                .joins("JOIN products ON (product_id = products.id)")

    user =  user.group(:order_id) if (type == 'Single')

    user =  user.group(["users.id", :first_name, :last_name])
                .order("#{aggr}(quantity * price) DESC")
                .limit(1)

    ["Highest #{type} Order Value", user[0].name, ActionController::Base.helpers.number_to_currency(user[0].quantity)]
  end




end
