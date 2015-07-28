class AddressesController < ApplicationController
  def index
    
    @addresses = if params[:user_id]
      @addresses = Address.where("user_id = #{params[:user_id]}")
    else
      Address.all
    end
  end

  def show
  end
end
