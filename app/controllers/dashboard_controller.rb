class DashboardController < ApplicationController

  include DashboardHelper

  def index

    @data = { 'Last 7 Days' => aggregate_data(7),
              'Last 30 Days' => aggregate_data(30),
              'Total' => aggregate_data
            }
  end

end
