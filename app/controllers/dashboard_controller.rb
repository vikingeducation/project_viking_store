class DashboardController < ApplicationController
	def index
		@users = User.all.limit(10)
		@orders = Order.all.limit(10)
		@top_states = User.top_states
		@top_cities = User.top_cities
	end
end
