class Order < ActiveRecord::Base

  belongs_to :user
  accepts_nested_attributes_for :user

  has_many :order_contents, :class_name => 'OrderContents'
  # possible ruby version has issues with delete_all when destroying under has_many association, rip orphans

  accepts_nested_attributes_for :order_contents,
                                :reject_if => proc { |attributes| attributes['quantity'].to_i < 0 },
                                :allow_destroy => true
  
  has_many :products, :through => :order_contents
  has_many :categories, :through => :products

  belongs_to :billing_address, :class_name => 'Address', 
                               :foreign_key => :billing_id
  belongs_to :shipping_address, :class_name => 'Address', 
                                :foreign_key => :shipping_id
  belongs_to :billing_card, :class_name => 'CreditCard',
                            :foreign_key => :billing_card_id
  accepts_nested_attributes_for :billing_card,
                                :reject_if => :all_blank,
                                :allow_destroy => true

  # Store Methods
  def update_quantity(product_id, amount)

    # order_content model
    self.order_contents.where(:product_id => product_id).first.increase_quantity(amount)

  end

  # Portal Methods
  def order_value

    self.products.sum("order_contents.quantity * products.price")

  end

  def self.get_index_data(user_id = nil)

    orders = Order.order("id DESC").limit(50)

    orders = orders.where(:user_id => user_id) if user_id

    orders.map do |order|
      {
        :relation => order,
        :user => order.user,
        :address => order.shipping_address,
        :quantity => order.count_total_quantity,
        :order_value => order.order_value,
        :status => order.order_status,
        :date_placed => order.checkout_date
      }
    end

  end

  def get_card_info

    self.billing_card.card_number if self.billing_card_id

  end

  def build_contents

    order_contents = self.order_contents.all.order(:product_id)

    order_contents.map do |row|
      {
        :relation => row,
        :product_id => row.product_id,
        :product_name => row.product.name,
        :quantity => row.quantity,
        :price => row.product.price,
        :total_price => row.quantity * row.product.price
      }
    end

  end

  def count_total_quantity

    self.order_contents.sum(:quantity)

  end

  def order_status

    if self.checkout_date
      'PLACED'
    else
      'UNPLACED'
    end

  end

  def update_checkout_date(new_status)

    if new_status == 'PLACED' && self.checkout_date.nil?
      DateTime.now
    elsif new_status == 'UNPLACED'
      nil
    end

  end

  # Dashboard Methods
  # method that controls day ranges for start AND end
  def self.within_days(day_range = nil, last_day = DateTime.now)
    if day_range.nil?
      where("orders.checkout_date IS NOT NULL")
    else
      where("orders.checkout_date BETWEEN ? AND ?", last_day - day_range.days, last_day)
    end
  end


  def self.count_orders(day_range = nil, last_day = DateTime.now)
    Order.within_days(day_range, last_day).count
  end



  # for all new orders within past x days
  def self.calc_revenue(day_range = nil)

    if day_range.nil?
      filter_query = Order.join_with_products.where("orders.checkout_date IS NOT NULL")
    else
      filter_query = Order.join_with_products.where("orders.checkout_date > ?", Time.now - day_range.days)
    end

    filter_query.sum("products.price * order_contents.quantity")
  end



  # grabs stats for a period of time.
  # can input number of days to include in the range, and the starting date to count backwards from
  # defaults to selecting all days in the database and using the current time as the starting point
  def self.order_stats_with_range(number_of_days = nil, last_day = DateTime.now)

    base_query = Order.select("COUNT(DISTINCT orders.id) AS count,
                               SUM(products.price * order_contents.quantity) AS revenue,
                               SUM(products.price * order_contents.quantity) / COUNT(DISTINCT orders.id) AS average").
                        join_with_products

    filter_query = base_query.within_days(number_of_days, last_day).each.first

    {'Number of Orders' => filter_query.count,
     'Total Revenue' => filter_query.revenue,
     'Average Order Value' => filter_query.average,
     'Largest Order Value' => Order.largest_order(number_of_days, last_day)
    }

  end


  def self.largest_order(number_of_days, start)
    base_query = Order.select("orders.id,
                               SUM(products.price * order_contents.quantity) AS order_total").
                       join_with_products.
                       group("orders.id").
                       order("SUM(products.price * order_contents.quantity) DESC")

    # largest value from beginning of time
    full_query = base_query.within_days(number_of_days, start).first
    
    if full_query.nil?
      max_order = nil
    else
      max_order = full_query.order_total
    end

    max_order

  end

  def self.join_with_products
    join_order_with_order_contents.join_order_contents_with_products
  end

  # grabs contents of orders
  def self.join_order_with_order_contents
    joins("JOIN order_contents ON orders.id = order_contents.order_id")
  end

  # grabs products of content
  def self.join_order_contents_with_products
    joins("JOIN products ON order_contents.product_id = products.id")
  end
  
end
