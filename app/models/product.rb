class Product < ActiveRecord::Base
  before_validation :prepare_number
  validates :price,
            presence: true,
            numericality: { less_than_or_equal_to: 10_000 }

  def prepare_number
    without_numsign = price.gsub(/$/, "")
    without_numsign.to_i
  end

  def self.total_products
    count
  end

  def self.day_products_total(day)
    where("created_at > ? ", day.days.ago).count
  end

  def product_category
    Category.where("id = #{self.category_id}")[0].name
  end

  def get_orders
    OrderContent.joins("JOIN orders ON (orders.id = order_contents.order_id)").where("product_id = #{self.id} AND orders.checkout_date IS NOT NULL")
  end

  def times_ordered
    get_orders.count *  get_orders.sum(:quantity)
  end

  def num_in_carts
    OrderContent.joins("JOIN orders ON (orders.id = order_contents.order_id)").where("product_id = #{self.id} AND orders.checkout_date IS NULL").count
  end

end
