class AddressesController < ApplicationController

  layout "admin_portal"

  def index
    @column_headers = ["ID","User","Address","City","State","Orders Shipped To","Created","SHOW","EDIT","DELETE"]
    @addresses = Address.all
  end

end
