class DashboardController < ApplicationController

  def home
    d = Dashboard.new
    @panels = d.build_panels
  end


end
