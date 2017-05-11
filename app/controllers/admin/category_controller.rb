class Admin::CategoryController < ApplicationController

  layout "admin"

  def index
    @categories = Category.all
  end

  def show
  end
end
