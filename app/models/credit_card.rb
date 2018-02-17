class CreditCard < ApplicationRecord

  has_many :orders
  belongs_to :user

  validates :card_number,
            length: {:is => 16}
  
  def expiration_str
    "#{self.exp_year}/#{self.exp_month}"
  end

end
