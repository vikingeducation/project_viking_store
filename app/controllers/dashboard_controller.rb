class DashboardController < ApplicationController

  def index
    # Assign arrays to the hash based on the starting values for the hash.
    @overall = {'Last 7' => 7, 'Last 30' => 30, 'Total' => nil}
    @overall.each do |key, limit|
      result = []
      result << User.in_last(limit)
      result << Order.in_last(limit)
      result << Product.in_last(limit)
      result << Order.revenue_in_last(limit)
      @overall[key] = result
    end

    @demographics = {'Top 3 states' => [], 'Top 3 cities' => [] }
    @demographics.each do |key|
      top_states = User.top_states
      p top_states
      top_states.each do |state|
        p state
        @demographics[key] << [state.name, state.total]
      end
    end
  end
end
