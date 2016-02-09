class DashboardController < ApplicationController
  def index
    @categories = Category.all
    @category_options = Category.all.map{ |c| [c.name, c.id] }
  end
end