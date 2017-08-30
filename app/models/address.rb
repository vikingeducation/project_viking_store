class Address < ApplicationRecord
  # An Address belongs to a single User.
  belongs_to :user
end
