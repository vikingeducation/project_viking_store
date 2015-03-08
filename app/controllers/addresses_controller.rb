class AddressesController < ApplicationController
  layout "admin", only: [:index, :new, :show, :edit]
  def index
    user_id = params[:user_id]
    if User.find(user_id)
      @addresses = Address.where("user_id = ?", user_id)
    else
      @addresses = Address.all
    end
  end

end
