class Category < ApplicationRecord

  has_many :products, dependent: :nullify
  has_many :orders, through: :products

  validates :name,
            presence: true,
            length: {:in => 4..16}

  def self.dropdown
    names = all.order('name')
  end

end
