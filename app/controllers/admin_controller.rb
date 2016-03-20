class AdminController < ApplicationController

  layout "admin_portal"

  def index

  end

  def categories
    @column_names = Category.column_names
  end

end
