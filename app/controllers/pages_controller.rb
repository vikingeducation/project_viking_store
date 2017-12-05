class PagesController < ApplicationController

  def dashboard

    @dashboard = Dashboard.new

  end
end
