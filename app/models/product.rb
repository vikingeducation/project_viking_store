class Product < ActiveRecord::Base
  include Recentable
  belongs_to :category, inverse_of: :products
  has_many :order_contents

  def times_ordered
    order_contents.joins(:order).where("orders.checkout_date IS NOT NULL").count
  end

  def carts_in
    order_contents.joins(:order).where("orders.checkout_date IS NULL").count
  end
end
