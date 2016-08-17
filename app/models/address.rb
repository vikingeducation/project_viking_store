class Address < ActiveRecord::Base
  belongs_to :city
  belongs_to :state

  belongs_to :user

  has_many :orders_billed_here, class_name: "Order", foreign_key: :billing_id

  validates :city, :state, :street_address, presence: true

  validates :street_address, length: { maximum: 64 }

  def owner_id
    user.id
  end

  def owner_name
    user.name
  end
end
