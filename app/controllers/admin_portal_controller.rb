class AdminPortalController < ApplicationController
  def home
    flash[:notify] = "Test flash message."
  end
end
