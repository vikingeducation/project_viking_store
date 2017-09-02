class CreditCard < ApplicationRecord
  # a CreditCard can only belong to a single User.
  belongs_to :user

  # a CreditCard can be used to pay for many Orders.
  # if a User and his CreditCards are destroyed, we want
  # to preserve Orders.
  has_many :orders, dependent: :nullify
end
