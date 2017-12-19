class Address < ApplicationRecord

  belongs_to :user
  belongs_to :order
  belongs_to :city
  belongs_to :state

  validates :city_id, :state_id, presence: true

  validates :street_address,
            presence: true,
            length: {in: 3..64}

  validates :zip_code,
            presence: true,
            length: {in: 5..10}

  after_create :assign_as_default

  def dropdown
    "#{street_address}, #{city.name}, #{state.abbreviation} #{zip_code}"
  end

  def assign_as_default
    u = self.user
    if u.billing_id == nil && u.shipping_id == nil
      u.billing_id = self.id
      u.shipping_id = self.id
      u.save
    elsif u.billing_id == nil
      u.billing_id = self.id
      u.save
    elsif u.shipping_id == nil
      u.shipping_id = self.id
      u.save
    else
    end

  end

end
