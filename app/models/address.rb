class Address < ApplicationRecord
  validates :street_address,
            :state_id,
            presence: true

  validates :street_address,
            length: { maximum: 64 }

  validates_presence_of :city_id, message: "can't be blank or is too long (maximum is #{City::MAX_NAME_LENGTH} characters)"

  # An Address belongs to a single User.
  belongs_to :user

  # An Address has a City and a State associated with it.
  belongs_to :city
  belongs_to :state

  def to_s
    [self.street_address, self.city.name, StatesHelper::STATE_POSTAL_CODES.key(self.state.name)].join(", ")
  end
end
