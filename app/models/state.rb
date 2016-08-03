class State < ActiveRecord::Base

	def self.top_states(limit = 3)
		top_states = []

		s = State.joins("JOIN addresses ON states.id = state_id JOIN users ON addresses.id = users.billing_id").group("states.id").select("states.name, count (states.id) as total").order("total desc").limit(limit)

		s.each do |state|
			top_states << { name: state.name, total: state.total }
		end

		top_states
	end



end
