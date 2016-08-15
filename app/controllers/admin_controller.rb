class AdminController < ApplicationController
  layout 'admin'

  def portal
    @categories = Category.all
    render 'categories/index'

  end

  def categories

  end
end
