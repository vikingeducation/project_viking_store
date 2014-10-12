class AddressesController < ApplicationController
  def index
    @addresses=Address.all
    render :layout => "admin_interface"
  end
  def show
    @address = Address.find(params[:id])
    render :layout => "admin_interface"
  end
  
  def new
    @address = Address.new
    render :layout => "admin_interface"
  end
end
