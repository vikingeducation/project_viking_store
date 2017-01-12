class User < ApplicationRecord

  has_many :credit_cards, :dependent => :destroy
  has_many :orders, :dependent => :nullify
  has_many :addresses, :dependent => :nullify
  belongs_to :default_billing, :foreign_key => :billing_id, :class_name => "Address"
  belongs_to :default_shipping, :foreign_key => :shipping_id, :class_name => "Address"

  validates :first_name, :last_name, :email, :presence => true,
                                             :length => { in: 1..64 }
  validates :email, :format => { :with => /@/ }

  def last_order_date(user)
    user.orders.select('checkout_date').where('checkout_date IS NOT NULL').order('checkout_date DESC').limit(1)[0].checkout_date
  end

  def self.total(num_days=nil)
    if num_days
      User.where("created_at > ?", num_days.days.ago).count
    else
      User.all.count
    end
  end

  def self.highest_single_order_value
    User.select("MAX(quantity*price) as order_value, CONCAT(first_name, ' ', last_name) AS name")
    .joins("JOIN orders ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = product_id")
    .group("users.id")
    .order("order_value DESC")
    .limit(1)
  end

  def self.highest_lifetime_value
    User.select("SUM(quantity*price) as lifetime, CONCAT(first_name, ' ', last_name) AS name")
    .joins("JOIN orders ON users.id = orders.user_id JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = product_id")
    .group("users.id")
    .order("lifetime DESC")
    .limit(1)
  end

  def self.highest_average_order_value
    User.select("AVG(users.id) as average, CONCAT(first_name, ' ', last_name) AS name")
    .joins("JOIN orders ON users.id = orders.user_id")
    .group("users.id")
    .order("average DESC")
    .limit(1)
  end

  def self.most_orders_placed
    # User.find_by_sql("
    #   SELECT COUNT(users.id) AS num_orders, users.first_name, users.last_name
    #     FROM users
    #     JOIN orders ON users.id = orders.user_id
    #     GROUP BY users.id
    #     ORDER BY num_orders DESC
    #     LIMIT 1
    #   ")

    User.select("COUNT(users.id) AS num_orders, CONCAT(first_name, ' ', last_name) AS name")
        .joins("JOIN orders ON users.id = orders.user_id")
        .group("users.id")
        .order("num_orders DESC")
        .limit(1)
  end

end
