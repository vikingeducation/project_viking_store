class Address < ApplicationRecord

  belongs_to :city
  belongs_to :state
  belongs_to :user
  has_many :orders

  validates :street_address,
            :length => {:in => 3..64},
            presence: true

  validates :city_id,
            :state_id,
            presence: true


  def city_name=(name)
    self.city = City.find_or_initialize_by(name: name)
    city.save
  end

  def city_name
    city ? city.name : nil
  end

end
