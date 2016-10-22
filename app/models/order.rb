class Order < ApplicationRecord
  belongs_to :user, foreign_key: :user_id
  belongs_to :shipping_address, foreign_key: :shipping_id, class_name: "Address"
  belongs_to :billing_address, foreign_key: :billing_id, class_name: "Address"

  has_many :order_contents, dependent: :destroy
  has_many :products, :through => :order_contents, :source => :product
  belongs_to :credit_card

  validates :user_id, presence: true, numericality: { is_integer: true }

  accepts_nested_attributes_for :order_contents, :reject_if => :all_blank, :allow_destroy => true

  def quantity
    order_contents.sum(:quantity)
  end

  def value
    products.sum("quantity * price")
  end

  def checked_out?
    checkout_date.present?
  end

  def self.checked_out
    where("checkout_date IS NOT NULL")
  end

end
