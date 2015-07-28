class Address < ActiveRecord::Base

  validates :zip_code, :city_id, :state_id, :user_id,
            presence: true
  validates :street_address, presence: true, length: {in: 1..64}

  belongs_to :user
  has_many :users, foreign_key: :billing_id, dependent: :nullify
  has_many :users, foreign_key: :shipping_id, dependent: :nullify

  belongs_to :city
  belongs_to :state

  has_many :orders, foreign_key: :billing_id, dependent: :nullify
  has_many :orders, foreign_key: :shipping_id, dependent: :nullify

  def full_address
    self.street_address + ", " + self.city.name + ", " + self.state.name
  end

  def self.get_demographics
    demographics = {'Top 3 states' => [], 'Top 3 cities' => [] }
    self.top_states.each do |state|
      demographics['Top 3 states'] << [state.name, state.total]
    end

    self.top_cities.each do |city|
      demographics['Top 3 cities'] << [city.name, city.total]
    end
    demographics
  end


  def self.top_states
    State.joins(:addresses).select(" states.name, COUNT(addresses) as total").order("COUNT(addresses) DESC").group("states.id").limit(3)
  end

  def self.top_cities
    City.joins(:addresses).select(" cities.name, COUNT(addresses) as total").order("COUNT(addresses) DESC").group("cities.id").limit(3)
  end
end
