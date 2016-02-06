class User < ActiveRecord::Base
  attr_accessor :city_name

  has_many :orders
  has_many :products, through: :orders
  has_many :addresses

  belongs_to :default_billing_address,
            class_name: "Address",
            foreign_key: :billing_id

  belongs_to :default_shipping_address,
            class_name: "Address",
            foreign_key: :shipping_id

  has_one :default_billing_city,
              through: :default_billing_address,
              source: :city


  has_one :default_shipping_city,
              through: :default_shipping_address,
              source: :city

  has_one :default_billing_state,
              through: :default_billing_address,
              source: :state


  has_one :default_shipping_state,
              through: :default_shipping_address,
              source: :state

  has_one :credit_card


  validates :first_name, :last_name, :email,
            :presence => true, 
            :length =>{ 
                      :in => 1..63, # same as above
            }

  validates :email,
            :uniqueness => true

  validates :email,
            :format => { :with => /@/ }


  def self.total(days=nil)
    if days.nil?
      self.all.count
    else
      self.all.where("created_at > CURRENT_DATE - interval '#{days} day' ").count
    end
  end

  def self.top_states
    self.select("COUNT(*) AS user_count, states.name").joins("JOIN addresses ON addresses.user_id = users.id").joins("JOIN states ON states.id = addresses.state_id").group("states.name").order("user_count DESC").limit(3)
  end

  def self.top_cities
    self.select("COUNT(*) AS user_count, cities.name").joins("JOIN addresses ON addresses.user_id = users.id").joins("JOIN cities ON cities.id = addresses.city_id").group("cities.name").order("user_count DESC").limit(3)
  end

  # def self.user_data
  #   self.select("users.id AS ID, users.first_name AS Name, users.created_at AS Joined, cities.name AS City, states.name AS state, COUNT(orders.id) AS Orders").
  #   joins("JOIN addresses ON addresses.id = users.billing_id").
  #   joins("JOIN cities ON addresses.city_id = cities.id").
  #   joins("JOIN states ON addresses.state_id = states.id").
  #   joins("JOIN orders ON orders.user_id = users.id").
  #   group("users.id, city, state").
  #   order("ID")
  # end


  def self.last_order_date(id)
    self.select("orders.checkout_date AS date").
    joins("JOIN orders ON orders.user_id = users.id").
    where("orders.checkout_date IS NOT NULL AND users.id = #{id}").
    order("orders.checkout_date DESC").
    limit 1
  end



end