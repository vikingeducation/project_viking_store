class Admin::DashboardController < ApplicationController

  include Admin::DashboardHelper

  def index

    @data = { "1. Overall Platform" => get_aggregate_data,
              "2. User Demographics and Behavior" => get_demographic_data,
              "3. Order Statistics" => get_order_stats,
              "4. Time Series Data" => get_time_series
            }

  end

end
