class State < ActiveRecord::Base

	def self.total_states
		top_states = []

		s = State.joins("JOIN addresses ON states.id = state_id JOIN users ON addresses.id = users.billing_id").group("states.id").select("count (states.id) as total").order("total desc").limit(3)



	end



end
