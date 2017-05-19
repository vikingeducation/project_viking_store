require 'pry'

class Order < ApplicationRecord

  belongs_to :billing, class_name: "Address", :foreign_key => :billing_id
  belongs_to :shipping, class_name: "Address", :foreign_key => :shipping_id
  belongs_to :user
  belongs_to :credit_card

  has_many :order_contents, :dependent => :destroy
  has_many :products, :through => :order_contents
  has_many :categories, :through => :products

  accepts_nested_attributes_for :order_contents,
                                :reject_if => :all_blank,
                                :allow_destroy => true


  def created_date
    created_at.strftime("%m/%d/%y")
  end

  def total_value
    total = 0
    self.order_contents.each do |cont|
      if Product.exists?(cont.product_id)
        total += cont.quantity*cont.product.price
      end
    end
    total
  end

  def check_status
    self.checkout_date.nil? ? "UNPLACED" : "PLACED"
  end

  def self.seven_days_orders
    where('created_at > ?', (Time.zone.now.end_of_day - 7.days)).count
  end

  def self.month_orders
    where('created_at > ?', (Time.zone.now.end_of_day - 30.days)).count
  end

  def self.total_orders
    count
  end


  def self.seven_days_revenue
    find_by_sql("
        SELECT SUM(price * quantity) AS sum FROM orders
        JOIN order_contents ON orders.id = order_contents.order_id
        JOIN products ON products.id = order_contents.product_id
        WHERE checkout_date IS NOT NULL
        AND orders.created_at > '#{Time.now - 30.days}'
      ")
  end

  def self.month_revenue
    find_by_sql("
        SELECT SUM(price * quantity) AS sum FROM orders
        JOIN order_contents ON orders.id = order_contents.order_id
        JOIN products ON products.id = order_contents.product_id
        WHERE checkout_date IS NOT NULL
        AND orders.created_at > '#{Time.now - 30.days}'
      ")
  end

  def self.num_of_orders(period = nil)
    if period
      where(:created_at => ((Time.now - period.days)..Time.now)).count
    else
      count
    end
  end

  def self.all_time_total_revenue
    select("sum(price * quantity) AS sum_orders").
    joins("JOIN order_contents ON orders.id = order_contents.order_id").
    joins("JOIN products ON products.id = order_contents.product_id")
  end

  def self.all_time_avg_revenue
    select("avg(price * quantity) AS avg_orders").
    joins("JOIN order_contents ON orders.id = order_contents.order_id").
    joins("JOIN products ON products.id = order_contents.product_id")
  end

  def self.all_time_biggest_order
    select("price * quantity AS order_value").
    joins("JOIN order_contents ON orders.id = order_contents.order_id").
    joins("JOIN products ON products.id = order_contents.product_id")
  end

  def self.total_revenue_checked(period = nil)
    # find_by_sql("
    #     SELECT SUM(price * quantity) AS sum FROM orders
    #     JOIN order_contents ON orders.id = order_contents.order_id
    #     JOIN products ON products.id = order_contents.product_id
    #     WHERE checkout_date IS NOT NULL
    #   ")
    if period
      all_time_total_revenue.
      where(:created_at => ((Time.now - period.days)..Time.now)).
      where.not(:checkout_date => nil)
    else
      all_time_total_revenue.
      where.not(:checkout_date => nil)
    end
  end

  def self.total_revenue(period = nil)
    if period
      all_time_total_revenue.
      where(:created_at => ((Time.now - period.days)..Time.now))
    else
      all_time_total_revenue
    end
  end

  def self.avg_order_val(period = nil)
    if period
      all_time_avg_revenue.
      where(:created_at => ((Time.now - period.days)..Time.now))
    else
      all_time_avg_revenue
    end
  end

  def self.large_order_val(period = nil)
    if period
      all_time_biggest_order.
      where(:created_at => ((Time.now - period.days)..Time.now)).
      order("order_value desc").
      limit(1)
    else
      all_time_biggest_order.
      order("order_value desc").
      limit(1)
    end
  end


  def update_attributes_extra(whitelisted_orders_params)
    self.combine_duplicate_products(whitelisted_orders_params)
    self.update_attributes(whitelisted_orders_params)
  end

  def combine_duplicate_products(whitelisted_orders_params)
    # binding.pry
    whitelisted_orders_params["order_contents_attributes"].each do |idx,param_cont|
      self.order_contents.each do |order_cont| 
        if param_cont["product_id"].to_i == order_cont.product_id
          order_cont.quantity += param_cont["quantity"].to_i
          order_cont.save
          param_cont["quantity"] = ""
          param_cont["product_id"] = ""
        end
      end
    end

  end

end
