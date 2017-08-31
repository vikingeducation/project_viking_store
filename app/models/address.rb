class Address < ApplicationRecord
  # An Address belongs to a single User.
  belongs_to :user

  # An Address has a City and a State associated with it.
  belongs_to :city
  belongs_to :state

  def to_s
    [self.street_address, self.city.name, StatesHelper::STATE_POSTAL_CODES.key(self.state.name)].join(", ")
  end
end
