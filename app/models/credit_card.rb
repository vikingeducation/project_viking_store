class CreditCard < ActiveRecord::Base
  belongs_to :user
  has_many :orders

  def expiration
    "#{exp_month}/#{exp_year}"
  end
end
