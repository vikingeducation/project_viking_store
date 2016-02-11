class AdminController < ApplicationController
  layout 'admin'

  def index
    @categories = Category.all
  end
end
