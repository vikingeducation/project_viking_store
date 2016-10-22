class User < ApplicationRecord
  has_many :orders
  has_many :products, :through => :order_contents
  has_many :addresses, dependent: :destroy
  has_one :credit_card, dependent: :destroy

  belongs_to :billing_address, class_name: "Address", :foreign_key => :billing_id
  belongs_to :shipping_address, class_name: "Address", :foreign_key => :shipping_id

  validates :first_name, :last_name, length: { maximum: 250 }, presence: true
  validates :email, presence: true, format: { with: /@/ }

  accepts_nested_attributes_for :addresses, :allow_destroy => true, :reject_if => :all_blank

  def completed_orders
    orders.where.not(checkout_date: nil)
  end

  def last_checkout_date
    orders.where.not(checkout_date: nil).order("checkout_date DESC").pluck(:checkout_date).first || "n/a"
  end
end
