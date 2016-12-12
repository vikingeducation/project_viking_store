class Order < ApplicationRecord
  belongs_to :address
  belongs_to :user
  belongs_to :credit_card
  has_many :order_contents

  def self.total_orders(day_number = nil)
    day_number.nil? ? Order.all.count : Order.all.where(created_at: day_number.days.ago.beginning_of_day..Time.now).count
  end

end
