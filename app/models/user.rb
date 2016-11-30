class User < ApplicationRecord

  def self.count_by_days(num_days)
    users = select('COUNT(*) AS u_count')
    users = users.where("created_at >= ?", num_days.days.ago) if num_days
    users[0].u_count
  end

  def self.count_by_demo(demographic, sort: "DESC", addr_type: "billing", limit: nil)
    plural = demographic.pluralize
    users = select("#{plural}.name AS name, COUNT(users.id) AS user_count")
                 .joins("JOIN addresses ON (addresses.id = users.#{addr_type}_id)")
                 .joins("JOIN #{plural} ON (#{plural}.id = addresses.#{demographic}_id)")
                 .group("#{plural}.name")
                 .order("COUNT(users.id) #{sort}")
    users.limit(limit) if limit

  end

  def self.greatest_revenue(type: "Lifetime", aggr: "SUM")
    user =  select("CONCAT(first_name,' ',last_name) as name, #{aggr}(quantity * price) as quantity")
                .joins("JOIN orders ON (user_id = users.id)")
                .joins("JOIN order_contents ON (order_id = orders.id)")
                .joins("JOIN products ON (product_id = products.id)")

    user =  user.group(:order_id) if (type == 'Single')

    user =  user.group(["users.id", :first_name, :last_name])
                .order("#{aggr}(quantity * price) DESC")
                .limit(1)

    user[0]
  end

  def self.most_orders
    user =  select("CONCAT(first_name,' ',last_name) as name, COUNT(orders.id) as quantity")
                .joins("JOIN orders ON (user_id = users.id)")
                .group(["users.id", :first_name, :last_name])
                .order("COUNT(orders.id) DESC")
                .limit(1)
    user[0]
  end

end
