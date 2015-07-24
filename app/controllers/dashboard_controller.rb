class DashboardController < ApplicationController

  def index
    # Assign arrays to the hash based on the starting values for the hash.
    @overall = User.get_overall

    @demographics = User.get_demographics

    @superlatives = User.get_superlatives

    @statistics = Order.get_statistics
  end
end
