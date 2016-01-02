class Product < ActiveRecord::Base
  belongs_to :category
  has_many :order_contents, dependent: :destroy
  has_many :orders, through: :order_contents

  validates :name, :price, :category_id, presence: true
  validates :price, numericality: {less_than_or_equal_to: 10000, greater_than: 0}

  scope :days_ago, -> (days_past = 7) { where("created_at > ?", days_past.days.ago) }
  scope :day_range, -> (start_day, end_day) {where("created_at >= ? AND created_at <= ?", start_day.days.ago, end_day.days.ago)}

  def times_ordered
    self.orders.completed.count
  end

  def carts_in
    self.orders.where("orders.checkout_date IS NULL").count
  end
end
