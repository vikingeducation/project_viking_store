class User < ActiveRecord::Base

  # I think credit_cards should be destroyed when a user is destroyed.
  has_one :credit_card, :dependent => :destroy

  # Should you delete an address because the user is gone, I guess we shouldn't because a lot of stats are done from those addresses, but I guess we can nullify and it shouldn't make a big deal.

  # has_many :addresses, :dependent => :nullify

  # didnt want to just nullify, wanted to destroy shopping carts then nullify.
  has_many :orders, :dependent => :delete_shopping_cart

  has_many :products, :through => :orders

  validates_length_of :first_name, :last_name, :email, :within => 1..64
  validates :email, 
            :format => { :with => /@/ }

  def delete_shopping_cart
    self.orders.each do |order|
      if order.checkout_date == nil
        Order.destroy(order.id)
      else
        order.update_attribute(:checkout_date, nil)
      end
    end
  end

  def city_name
    if self.billing_id
      City.find(Address.find(billing_id).city_id).name
    else
      'n/a'
    end
  end

  def default_billing_address
    if self.billing_id
      address = Address.find(self.billing_id)
      # This ternary expression seems to just complicate things but I'm using it for practice
      address.secondary_address ? "#{address.street_address}, #{address.secondary_address}, #{city_name(address)}, #{state_name(address)}, #{address.zip_code}" : "#{address.street_address}, #{city_name(address)}, #{state_name(address)}, #{address.zip_code}"
    else
      "n/a"
    end
  end

  def default_shipping_address
    if self.shipping_id
      address = Address.find(self.shipping_id)
      # This ternary expression seems to just complicate things but I'm using it for practice
      address.secondary_address ? "#{address.street_address}, #{address.secondary_address}, #{city_name(address)}, #{state_name(address)}, #{address.zip_code}" : "#{address.street_address}, #{city_name(address)}, #{state_name(address)}, #{address.zip_code}"
    else
      "n/a"
    end
  end

  def last_order_date(user_id)
    unless Order.where(:user_id => user_id).where.not(:checkout_date => nil).order(:updated_at => :desc).limit(1).empty?
      Order.where(:user_id => user_id).where.not(:checkout_date => nil).order(:updated_at => :desc).limit(1).first.updated_at
    else
      'n/a'
    end
  end

  def number_of_orders(user_id)
    Order.where(:user_id => user_id).count
  end

  def state_name
    if self.billing_id
      State.find(Address.find(billing_id).state_id).name
    else
      'n/a'
    end
  end

  def self.created_since_days_ago(number)
    User.all.where('created_at >= ?', number.days.ago).count
  end

  # Field: Highest single order value and the customer who achieved it
  # Tables needed:
    # users for user first_name and last_name
    # orders so that I can make sure that the order was actually ordered via checkout_date
    # order_contents so that I can see which orders had which product_ids and quantity
    # products so that I can see see what those products prices are.
  # First I connect orders and order_contents so that we can filter our all the order_contents that haven't been checked out yet
    # Order.find_by_sql("SELECT * FROM orders JOIN order_contents ON orders.id=order_contents.order_id WHERE orders.checkout_date IS NOT NULL")
  # Now I need to join on products so that i can make an extra column which multiplies order_contents.quantity by products.price
    # Order.find_by_sql("SELECT *, (order_contents.quantity * products.price) as sub FROM orders JOIN order_contents ON orders.id=order_contents.order_id JOIN products ON order_contents.product_id=products.id WHERE orders.checkout_date IS NOT NULL")
  # Next I gotta group by the order_id and get the total of sub
  # This gets me a table with the order_id and the total cost of each one
  # I've also ordered it descending on the total and limited it to 1 result.
    # a = Order.find_by_sql("SELECT order_contents.order_id, SUM(order_contents.quantity * products.price) as total FROM orders JOIN order_contents ON orders.id=order_contents.order_id JOIN products ON order_contents.product_id=products.id WHERE orders.checkout_date IS NOT NULL GROUP BY order_contents.order_id ORDER BY total DESC LIMIT 1")
  # Making this a subquery and joining orders and users tables to it.

  def self.biggest_single_order
    User.find_by_sql("SELECT * 
                      FROM orders 
                      JOIN (SELECT order_contents.order_id, SUM(order_contents.quantity * products.price) as amount 
                            FROM orders 
                            JOIN order_contents 
                              ON orders.id=order_contents.order_id 
                            JOIN products 
                              ON order_contents.product_id=products.id 
                            WHERE orders.checkout_date IS NOT NULL 
                            GROUP BY order_contents.order_id 
                            ORDER BY amount DESC 
                            LIMIT 1) AS sub 
                        ON orders.id = sub.order_id 
                      JOIN users 
                        ON orders.user_id=users.id")
  end

=begin
  # Field: Highest Lifetime value customer (by total revenue generated)
  Alot like the last one except I want to group by the user_id this time.

  a = Order.find_by_sql("SELECT orders.user_id, SUM(order_contents.quantity * products.price) as amount FROM orders JOIN order_contents ON orders.id=order_contents.order_id JOIN products ON order_contents.product_id=products.id WHERE orders.checkout_date IS NOT NULL GROUP BY orders.user_id ORDER BY amount DESC LIMIT 1")

  User.find_by_sql("SELECT * FROM (SELECT orders.user_id, SUM(order_contents.quantity * products.price) as amount FROM orders JOIN order_contents ON orders.id=order_contents.order_id JOIN products ON order_contents.product_id=products.id WHERE orders.checkout_date IS NOT NULL GROUP BY orders.user_id ORDER BY amount DESC LIMIT 1) AS biggest JOIN users ON biggest.user_id=users.id")

  Now I can use this as a sub query to join up with users


=end

  def self.biggest_lifetime_spender
    User.find_by_sql("SELECT * 
                      FROM (SELECT orders.user_id, SUM(order_contents.quantity * products.price) AS amount 
                            FROM orders 
                            JOIN order_contents 
                              ON orders.id=order_contents.order_id 
                            JOIN products 
                              ON order_contents.product_id=products.id 
                            WHERE orders.checkout_date IS NOT NULL 
                            GROUP BY orders.user_id 
                            ORDER BY amount DESC 
                            LIMIT 1) AS biggest 
                      JOIN users 
                        ON biggest.user_id=users.id")
  end

=begin
  Field: Highest average order value and the customer who placed it
  I was thinking you want a table
  user_id total_life_time_spend total_number_of_orders_made total_life_time_spend/total_number_of_orders_made
  lets focus on one thing at a time
  
  # This gets me all the user_ids and their total life time spends.
  Order.find_by_sql("SELECT orders.user_id, SUM(order_contents.quantity * products.price) as amount FROM orders JOIN order_contents ON orders.id=order_contents.order_id JOIN products ON order_contents.product_id=products.id WHERE orders.checkout_date IS NOT NULL GROUP BY orders.user_id")

  # Now I want to get a user.id and the count of the orders they've made
  Order.find_by_sql("SELECT orders.user_id, COUNT(orders.id) as total_orders FROM orders WHERE orders.checkout_date IS NOT NULL GROUP BY orders.user_id")

  # Now I want to join these two tables
  Order.find_by_sql("SELECT * FROM (SELECT orders.user_id, COUNT(orders.id) as total_orders FROM orders WHERE orders.checkout_date IS NOT NULL GROUP BY orders.user_id) AS number_of_orders JOIN (SELECT orders.user_id, SUM(order_contents.quantity * products.price) as amount FROM orders JOIN order_contents ON orders.id=order_contents.order_id JOIN products ON order_contents.product_id=products.id WHERE orders.checkout_date IS NOT NULL GROUP BY orders.user_id) AS lifetime_orders ON number_of_orders.user_id=lifetime_orders.user_id")

  # Now I want to make an extra column by dividing the total by the number
  Order.find_by_sql("SELECT *, (lifetime_orders.amount/number_of_orders.total_orders) AS average_order FROM (SELECT orders.user_id, COUNT(orders.id) as total_orders FROM orders WHERE orders.checkout_date IS NOT NULL GROUP BY orders.user_id) AS number_of_orders JOIN (SELECT orders.user_id, SUM(order_contents.quantity * products.price) as amount FROM orders JOIN order_contents ON orders.id=order_contents.order_id JOIN products ON order_contents.product_id=products.id WHERE orders.checkout_date IS NOT NULL GROUP BY orders.user_id) AS lifetime_orders ON number_of_orders.user_id=lifetime_orders.user_id ORDER BY average_order DESC LIMIT 1")

  # Now I want to join the users table to this:
  # Note I had to change the above query from "SELECT *, (life..." to "SELECT orders.user_id, (life..." otherwise that table would have two user_ids which would blow things up.
  Order.find_by_sql("SELECT * FROM(SELECT number_of_orders.user_id, (lifetime_orders.amount/number_of_orders.total_orders) AS average_order FROM (SELECT orders.user_id, COUNT(orders.id) as total_orders FROM orders WHERE orders.checkout_date IS NOT NULL GROUP BY orders.user_id) AS number_of_orders JOIN (SELECT orders.user_id, SUM(order_contents.quantity * products.price) as amount FROM orders JOIN order_contents ON orders.id=order_contents.order_id JOIN products ON order_contents.product_id=products.id WHERE orders.checkout_date IS NOT NULL GROUP BY orders.user_id) AS lifetime_orders ON number_of_orders.user_id=lifetime_orders.user_id ORDER BY average_order DESC LIMIT 1) AS average_table JOIN users ON average_table.user_id=users.id")
=end
  def self.biggest_average_spender
    User.find_by_sql("SELECT * 
                      FROM (SELECT number_of_orders.user_id, (lifetime_orders.amount/number_of_orders.total_orders) AS average_order 
                            FROM (SELECT orders.user_id, COUNT(orders.id) AS total_orders 
                                  FROM orders 
                                  WHERE orders.checkout_date IS NOT NULL 
                                  GROUP BY orders.user_id) AS number_of_orders 
                            JOIN (SELECT orders.user_id, SUM(order_contents.quantity * products.price) as amount 
                                  FROM orders 
                                  JOIN order_contents 
                                    ON orders.id=order_contents.order_id 
                                  JOIN products 
                                    ON order_contents.product_id=products.id 
                                  WHERE orders.checkout_date IS NOT NULL 
                                  GROUP BY orders.user_id) AS lifetime_orders 
                              ON number_of_orders.user_id=lifetime_orders.user_id 
                            ORDER BY average_order DESC 
                            LIMIT 1) AS average_table 
                      JOIN users 
                        ON average_table.user_id=users.id")
  end

=begin
  Field: Most orders placed and the customer who placed it

  This is just a small part of that big one we just did above:
  # Now I want to get a user.id and the count of the orders they've made
    Order.find_by_sql("SELECT orders.user_id, COUNT(orders.id) as total_orders FROM orders WHERE orders.checkout_date IS NOT NULL GROUP BY orders.user_id ORDER BY total_orders DESC LIMIT 1")

  # Now I'll just join that with the users table:
    Order.find_by_sql("SELECT * FROM (SELECT orders.user_id, COUNT(orders.id) as total_orders FROM orders WHERE orders.checkout_date IS NOT NULL GROUP BY orders.user_id ORDER BY total_orders DESC LIMIT 1) AS total_orders JOIN users ON total_orders.user_id=users.id")

=end

  def self.most_orders_placed
    User.find_by_sql("SELECT * 
                      FROM (SELECT orders.user_id, COUNT(orders.id) AS total_orders 
                            FROM orders 
                            WHERE orders.checkout_date IS NOT NULL 
                            GROUP BY orders.user_id 
                            ORDER BY total_orders DESC 
                            LIMIT 1) AS total_orders 
                      JOIN users 
                        ON total_orders.user_id=users.id")
  end
end
