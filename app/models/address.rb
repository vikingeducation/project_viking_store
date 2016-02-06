class Address < ActiveRecord::Base
  belongs_to :user

  has_many :order_contents, :through => :user
  has_many :orders, :through => :order_contents, source: :order

  validates :street_address, length: { in: 1..64 }

  def state
    State.find(self.state_id)
  end

  def city
    City.find(self.city_id)
  end
end
