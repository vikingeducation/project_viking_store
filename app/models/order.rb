class Order < ActiveRecord::Base

  belongs_to :billings, :class_name => "Address", :foreign_key => :billing_id
  belongs_to :shippings, :class_name => "Address", :foreign_key => :shipping_id
  belongs_to :user
  has_many :order_contents
  has_many :products, :through => :order_contents

  # scope examples...
  # scope :checked_out, lambda { where("checkout_date IS NOT NULL") }
  # scope :not_checked_out, lambda { where("checkout_date IS NULL") }

  def self.created_since_days_ago(number)
    Order.where('checkout_date >= ?', number.days.ago).count
  end
end
