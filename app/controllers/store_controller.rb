class StoreController < ApplicationController

  def index
    redirect_to store_products_path
  end
end
