class OrderContent < ApplicationRecord
  belongs_to :order
  belongs_to :product

  def self.total
    sum(:quantity)
  end
end
