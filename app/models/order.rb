class Order < ApplicationRecord

  belongs_to :user

  has_one :billing_address, :class_name => 'Address'
  has_one :shipping_address, :class_name => 'Address'

  has_many :order_contents, dependent: :destroy
  has_many :contents, foreign_key: 'order_id', class_name: 'OrderContent'

  has_many :products, through: :order_contents

  include SharedQueries


  def self.last_n_days(n)
    past = Date.today - n.days
    where("checkout_date > ?", past)
  end

  def self.total_revenue
    where("checkout_date IS NOT NULL").includes(:products).pluck(:price).reduce(&:+).to_f
  end

end
