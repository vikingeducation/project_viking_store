class User < ActiveRecord::Base
  has_many :addresses
  has_many :credit_cards, :dependent => :destroy
  has_many :orders   # :dependent => :destroy if: 

  has_many :products, :through => :orders

  belongs_to :billing_address, class_name: "Address",
                               foreign_key: :billing_id

  belongs_to :shipping_address, class_name: 'Address',
                                foreign_key: :shipping_id

  validates :first_name, :last_name, :email,
            :length => {in: (1..64)},
            :presence => true

  validates :email,
            format: { with: /@/ },
            confirmation: true

  validates_confirmation_of :email,
                            message: "should match confirmation"

  accepts_nested_attributes_for :addresses, 
                                :allow_destroy => true,
                                reject_if: ->(attributes){
                                attributes.except(:state_id).values.all?(&:blank?)}

  before_destroy :check_order_type

  def self.total
    User.all.count
  end

  def self.new_users(t)
    User.where("created_at > ?", Time.now- t*24*60*60).count
  end

  def self.single_highest_value
    User.select("users.first_name AS fname, users.last_name AS lname, (p.price * oc.quantity) AS total")
        .joins("JOIN orders o ON users.id = o.user_id")
        .joins("JOIN order_contents oc ON o.id = oc.order_id ")
        .joins("JOIN products p ON oc.product_id = p.id")
        .where("o.checkout_date IS NOT NULL")
        .order("total DESC")
        .limit(1)
  end

  def self.highest_lifetime_value
    User.select("users.first_name AS fname, users.last_name AS lname, SUM(p.price * oc.quantity) AS total")
        .joins("JOIN orders o ON users.id = o.user_id")
        .joins("JOIN order_contents oc ON o.id = oc.order_id")
        .joins("JOIN products p ON oc.product_id = p.id")
        .where("o.checkout_date IS NOT NULL")
        .group("users.id")
        .order("total DESC")
        .limit(1)
  end

  def self.highest_average_value
    User.select("users.first_name AS fname, users.last_name AS lname, AVG(p.price * oc.quantity) AS avg")
        .joins("JOIN orders o ON users.id = o.user_id")
        .joins("JOIN order_contents oc ON o.id = oc.order_id")
        .joins("JOIN products p ON oc.product_id = p.id")
        .where("o.checkout_date IS NOT NULL")
        .group("users.id")
        .order("avg DESC")
        .limit(1)

  end

  def self.most_orders_place
    User.select("users.first_name AS fname, users.last_name AS lname, COUNT(*) AS total")
        .joins("JOIN orders o ON users.id = o.user_id")
        .where("o.checkout_date IS NOT NULL")
        .group("users.id")
        .order("total DESC")
        .limit(1)

  end

  def full_name
    self.first_name + " " + self.last_name
  end

  def find_shipping_address
    Address.find(self.shipping_id).city.name unless self.shipping_id.nil?
  end

  def find_billing_address
    Address.find(self.billing_id).city.name unless self.billing_id.nil?
  end

  def placed_orders
    self.orders.where("checkout_date IS NOT NULL")
  end

  def last_order_date
    self.placed_orders.last.checkout_date unless self.orders.nil? || self.orders.where("checkout_date IS NOT NULL").empty? 
  end

  def existing_addresses
    self.addresses.where(:deleted => false)
  end

  def get_cart?
    self.orders.where("checkout_date IS NULL").count > 0
  end

  def cart
    self.orders.where("checkout_date IS NULL").first
  end



  private

  def check_order_type
    self.orders.each do |order|
      order.destroy unless order.is_placed # is_checkout(order)
    end
  end
end











