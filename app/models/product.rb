class Product < ActiveRecord::Base
  # You don't need to destroy or null a category when destroying a product.
  belongs_to :category
  # You would destroy all join table items in order contents that have that product_id in there. Again, annoys me the idea that if you delete a product, all previous order records have that item wiped out. 
  has_many :order_contents, :dependent => :destroy
  # No need to destroy an order cos you're destroying a product.
  has_many :orders, :through => :order_contents

  validates :name, :sku, :price, :category_id,
            :presence => true
  validates :price, numericality: { less_than_or_equal_to: 10000 }

  def self.created_since_days_ago(number)
    Product.all.where('created_at >= ?', number.days.ago).count
  end

  # Input a category_id, returns the category name.
  def category_name(category_id)
    Category.find(category_id).name
  end

  def self.format_price(price)
    price.scan(/\d+\.*/).join
  end

  # Number of orders this product has been in, not the total sold.
  # order_contents table has order_id, product_id and quantity columns.
  # If I can get a count of all the rows that have the product_id I'm looking for, that'd be the answer.
  def times_ordered(product_id)
    OrderContent.where('product_id = ?', product_id).count
  end

  # I want the number of shopping carts this product is in. This means I need to know what orders this product is in and how many of those orders have null as their checkout_date.
  # join up order_contents with orders
  # grab all the rows from that have my product_id
  # find all the rows that have null for their checkout_date.
  # piss
  def number_of_carts_in(product_id)
    OrderContent.find_by_sql("SELECT COUNT(*) AS total
                              FROM order_contents
                              JOIN orders
                                ON order_contents.order_id=orders.id
                              WHERE order_contents.product_id = #{product_id}
                              AND orders.checkout_date IS NULL")
  end

end
