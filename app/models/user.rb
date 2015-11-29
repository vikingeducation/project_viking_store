class User < ActiveRecord::Base
  extend DumpModels

  before_destroy :destroy_cart
  
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :nullify
  has_many :credit_cards, dependent: :destroy
  has_many :products, through: :orders
  belongs_to :default_billing_address, foreign_key: :billing_id, class_name: "Address"
  belongs_to :default_shipping_address, foreign_key: :shipping_id, class_name: "Address"

  validates :first_name, :last_name, :email, length: { in: 1..64 }
  validates :email, format: { with: /@/, message: "must contain @"},
                    confirmation: true,
                    uniqueness: true
  validates :email_confirmation, presence: true

  accepts_nested_attributes_for :addresses, allow_destroy: true,
                                            reject_if: :blank_address
  validates_associated :addresses

  accepts_nested_attributes_for :credit_cards, allow_destroy: true
  validates_associated :credit_cards

  accepts_nested_attributes_for :orders
  validates_associated :orders
  

  def display_address
    if addr = default_shipping_address
      {city: addr.city.name, state: addr.state.name}
    elsif addr = default_billing_address
      {city: addr.city.name, state: addr.state.name}
    elsif addr = addresses.first
      {city: addr.city.name, state: addr.state.name}
    else
      {city: "-", state: "-"}
    end
  end


  def cart
    if orders.any?
      orders.cart.first
    end
  end


  def last_order_date
    if orders.submitted.any?
      orders.order("checkout_date DESC").
      submitted.limit(1).first.checkout_date
    end
  end


  def self.total_signups(period = nil)
    total = User.select("COUNT(*) AS t")
    if period
      total = total.where( "created_at BETWEEN :start AND :finish",
                          { start: DateTime.now - period, finish: DateTime.now } )
    end
    total.to_a.first.t
  end


  def self.top_three_billing_cities
    User.select("cities.name, count(cities.id) as users_in_city").
         join_with_billing_addresses.group("cities.name").
         order("users_in_city DESC").limit(3)

  end


  def self.top_three_billing_states
    User.select("states.name, count(states.id) as users_in_state").
         join_with_billing_addresses.group("states.name").
         order("users_in_state DESC").limit(3)
  end


  def self.join_with_billing_addresses
    joins("JOIN addresses ON users.billing_id = addresses.id").
    joins("JOIN states ON addresses.state_id = states.id").
    joins("JOIN cities ON addresses.city_id = cities.id")
  end


  def destroy_cart
    cart.destroy if cart
  end


  # Normally :all_blank could be used but the city throws a monkey wrench
  # It seems multi level reject_if doesn't work.
  def blank_address(attributes)
    attributes['street_address'].blank? &&
    attributes['secondary_address'].blank? &&
    attributes['city_attributes']['name'].blank? &&
    attributes['state_id'].blank? &&
    attributes['zip_code'].blank?
  end


end
