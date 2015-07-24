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


  def top_user_with
    { "Highest single" => User.all.count,
              "Orders"=> Order.all.count,
              "Products" => Product.all.count,
              "Revenue" => Order.total(100000).round}

  end

  def highest_order_value #name, value
    self.joins("JOIN orders ON user.id = orders.user_id")
  end

  def highest_rev_tot

  end

  def highest_avg_order_value

  end

  def most_orders

  end


end
