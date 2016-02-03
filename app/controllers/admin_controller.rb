class AdminController < ApplicationController
  def index
    @categories = Category.all
  end
end
