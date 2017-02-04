class State < ApplicationRecord
	has_many :addresses, dependent: :nullify
end
