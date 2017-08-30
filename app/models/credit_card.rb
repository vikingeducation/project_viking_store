class CreditCard < ApplicationRecord
  # a CreditCard can only belong to a single User.
  belongs_to :user
end
