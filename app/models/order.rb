class Order < ApplicationRecord
  scope :placed, -> { where.not(checkout_date: nil) }
  scope :placed_since, ->(begin_date) {
    placed.where('checkout_date > ? AND checkout_date < ?', begin_date, Time.zone.now)
  }

  def self.placed_in_last(num_days)
    begin_date = eval("#{num_days}.days.ago")
    placed_since(begin_date)
  end
end
