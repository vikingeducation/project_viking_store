class AddressesController < ApplicationController
  def index
    if (params[:user_id] != nil)
      confirm_user_id
    else
      @addresses=Address.all
    end
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

def confirm_user_id
  if Address.where(id: params[:user_id]).empty?
      @addresses=Address.all
  else
      @addresses=Address.where(user_id: params[:user_id])
      @filtered = true
      @params_user_id = params[:user_id]
  end
end
