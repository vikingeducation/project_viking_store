# DB Schema
#   t.integer  "order_id",               null: false
#   t.integer  "product_id",             null: false
#   t.integer  "quantity",   default: 1, null: false
#   t.datetime "created_at"
#   t.datetime "updated_at"

class OrderContent < ActiveRecord::Base
  belongs_to :product
  belongs_to :order

  validates :quantity,  presence: true,
                        numericality: { greater_than_or_equal_to: 0 }
  validates :order_id,  presence: true,
                        numericality: { greater_than_or_equal_to: 0 }
  validates :product_id,  presence: true,
                          numericality: { greater_than_or_equal_to: 0 }

  def self.total_revenue
    OrderContent.joins(:product, :order).where("checkout_date IS NOT NULL").sum("quantity * price").to_f
  end
end
