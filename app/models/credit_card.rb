class CreditCard < ApplicationRecord

  has_many :orders
  belongs_to :user
  
  def expiration_str
    "#{self.exp_year}/#{self.exp_month}"
  end

end
