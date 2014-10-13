class User < ActiveRecord::Base

  has_many :addresses, :dependent => :destroy
  has_many :orders

  has_one :payment, :dependent => :destroy # CC info

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :first_name, presence: true, length: {maximum: 64}
  validates :last_name, presence: true, length: {maximum: 64 }
  validates :email, presence: true, length: {minimum: 1, maximum:64},
            format: { with: VALID_EMAIL_REGEX }

  after_destroy :cart_cleanup


  def self.user(time)
    User.where('created_at > ?',time).count
  end

  def self.all_time
  	User.count
  end

  def cart_cleanup
    self.orders.where(is_placed: false).each do |order|
      order.destroy
    end
  end


end
