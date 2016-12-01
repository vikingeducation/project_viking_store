class DashboardController < ApplicationController

  def index
    @infographics = Infographics.get_panels
  end

end
