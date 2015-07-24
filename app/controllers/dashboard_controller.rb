class DashboardController < ApplicationController

  def index
    # Assign arrays to the hash based on the starting values for the hash.
    @results = {'Last 7' => 7, 'Last 30' => 30, 'Total' => nil}
    @results.each do |key, limit|
      result = []
      result << User.in_last(limit)
      result << Order.in_last(limit)
      result << Product.in_last(limit)
      result << Order.revenue_in_last(limit)
      @results[key] = result
    end
  end
end
