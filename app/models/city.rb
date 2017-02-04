class City < ApplicationRecord
	has_many :addresses, dependent: :nullify
end
