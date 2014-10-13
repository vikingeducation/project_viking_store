class Address < ActiveRecord::Base

  validates :street_address, presence: true, length: {maximum: 64}
  validates :state, presence: true
  validates :city, presence: true, length: {maximum: 64}
  belongs_to :user



  def self.get_top_state(num)
    Address.group(:state).select("state, count(state) AS state_count").order("state_count DESC").limit(3)[num].state
  end

  def self.get_top_count(num)
    Address.group(:state).select("state, count(state) AS state_count").order("state_count DESC").limit(3)[num].state_count
  end

  def self.get_top_city(num)
    Address.group(:city).select("city, count(city) AS city_count").order("city_count DESC").limit(3)[num].city
  end

  def self.get_top_city_count(num)
    Address.group(:city).select("city, count(city) AS city_count").order("city_count DESC").limit(3)[num].city_count
  end
end
