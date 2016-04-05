class CreditCard < ActiveRecord::Base
  # YOu wouldn't delete a user because you're deleting their creidt card, and considering the user_id is on this side, you don't have to do anything.
  belongs_to :user

  has_many :orders, :dependent => :nullify

  def nickname
    @nickname || 'n/a'
  end
end
