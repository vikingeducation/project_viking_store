class Address < ApplicationRecord
  # An Address belongs to a single User.
  belongs_to :user

  # An Address has a City and a State associated with it.
  belongs_to :city
  belongs_to :state
end
