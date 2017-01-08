class DashboardsController < ApplicationController
  include DashboardsHelper

  def index
    @last_7 = metrics(7)
    @last_30 = metrics(30)
    @total = metrics
  end
  
end
