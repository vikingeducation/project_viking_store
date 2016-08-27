class User < ApplicationRecord
  has_many :addresses
  has_many :orders
  has_many :credit_cards, :dependent => :destroy

  has_many :products,
           :through => :orders

  belongs_to :default_billing_address,
             :foreign_key => :billing_id,
             class_name: "Address",
             optional: true

  belongs_to :default_shipping_address,
             :foreign_key => :shipping_id,
             class_name: "Address",
             optional: true

  validates :first_name, :last_name, :email,
            presence: true,
            :length => { :within => 1..64 }
  validates :email,
            :format => { :with => /@/ }

  def has_additional_unplaced_order?(order)
    my_orders = self.orders.where("id != #{order.id}")
    return my_orders.where("checkout_date IS null").empty? ? false : true
  end

  def has_unplaced_order?
    self.shopping_cart.empty? ? false : true
  end

  def shopping_cart
    self.orders.where("checkout_date IS null")
  end

  def self.new_signups_7
    User.where("created_at > '#{Time.now.to_date - 7}' ").count
  end

  def self.new_signups_30
    User.where("created_at > '#{Time.now.to_date - 30}'").count
  end

  def self.total_signups
    User.count
  end





end
