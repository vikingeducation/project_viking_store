class CreditCard < ActiveRecord::Base
  belongs_to :user
  has_many :orders, dependent: :nullify
end
