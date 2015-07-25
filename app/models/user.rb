class User < ActiveRecord::Base
  # has_many :addresses, :orders
  # belongs_to :billing_id, , :class_name => "Address"
  # belongs_to :shipping_id, , :class_name => "Address"

  def self.user_created_days_ago(num_days)
    self.where("created_at > ?",Time.now - num_days.day).count
  end


  def self.top_3_states

    table=self.joins("JOIN addresses ON users.billing_id = addresses.id").joins("JOIN states ON states.id = addresses.state_id").select("states.name, count(*) AS count").group("states.name").order(:count).reverse_order.limit(3)
    self.helphash(table)
  end

  def self.helphash(table)
    h={}
    t=table
    t.each do |el|
      h[el.name]=el.count
    end
    h
  end



  def self.top_3_cities
    table=self.joins("JOIN addresses ON addresses.user_id=users.id").joins("JOIN cities ON cities.id=addresses.city_id").select("cities.name, count(*) AS count ").group("cities.name").order(:count).reverse_order.limit(3)
    self.helphash(table)
  end


  def self.top_user_with
    { "Highest single order value" => highest_order_value,
      "Highest lifetime value"=> highest_rev_tot,
      "Highest average order volume" => highest_avg_order_value,
      "Most orders place" => most_orders
    }

  end

  def self.highest_order_value #name, value
    result = self.joins("JOIN orders ON users.id = orders.user_id") \
        .joins("JOIN order_contents ON orders.id = order_contents.order_id") \
        .joins("JOIN products ON order_contents.product_id = products.id") \
        .select("SUM(price * quantity) AS cost, order_id") \
        .group(:order_id).order("cost DESC").limit(1) #.sum(:cost)


    name = User.joins("JOIN orders ON users.id = orders.user_id") \
        .select("CONCAT(first_name, ' ', last_name) AS fullname") \
        .where("orders.id = #{result.first.order_id}")


    [name.first.fullname, result.first.cost.round]
  end

  def self.highest_rev_tot
    result = self.joins("JOIN orders ON users.id = orders.user_id") \
        .joins("JOIN order_contents ON orders.id = order_contents.order_id") \
        .joins("JOIN products ON order_contents.product_id = products.id") \
        .select("SUM(price * quantity) AS cost, user_id") \
        .group(:user_id).order("cost DESC").limit(1)


      name = User.select("CONCAT(first_name, ' ', last_name) AS fullname").where("users.id=#{result.first.user_id}")


    [name.first.fullname, result.first.cost.round]

  end

  def self.highest_avg_order_value
    result = self.joins("JOIN orders ON users.id = orders.user_id") \
        .joins("JOIN order_contents ON orders.id = order_contents.order_id") \
        .joins("JOIN products ON order_contents.product_id = products.id") \
        .select("SUM(price * quantity)/COUNT(DISTINCT orders.id) AS aver, order_id").group(:order_id).order("aver DESC").limit(1)

    name = User.joins("JOIN orders ON users.id = orders.user_id") \
        .select("CONCAT(first_name, ' ', last_name) AS fullname") \
        .where("orders.id = #{result.first.order_id}")

      [name.first.fullname, result.first.aver.round]
  end

  def self.most_orders
    result = self.joins("JOIN orders ON users.id = orders.user_id") \
        .select("COUNT(orders.id) AS amount, orders.user_id").group(:user_id).order("amount DESC").limit(1)

    name = User.select("CONCAT(first_name, ' ', last_name) AS fullname").where("users.id=#{result.first.user_id}")

    [name.first.fullname, result.first.amount.round]

  end


end
