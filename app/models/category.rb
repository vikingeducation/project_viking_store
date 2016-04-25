class Category < ActiveRecord::Base
  # You would not delete a product because you're getting rid of a category, you would nullify.
  has_many :products, dependent: :nullify

  validates :name,
            :length => {:in => 4..16}

end
