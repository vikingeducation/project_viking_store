class Address < ActiveRecord::Base

  belongs_to :user
  belongs_to :state
  belongs_to :city

  validates :street_address, length: { maximum: 128 },
                            presence: true

  validates :zip_code, numericality: { only_integer: true },
                       presence: true,
                       length: { is: 5 }

  validates :city_id, :state_id,
                      numericality: { only_integer: true },
                      presence: true

end
