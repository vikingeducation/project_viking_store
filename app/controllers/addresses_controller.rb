class AddressesController < ApplicationController
  def index
    @addresses = Address.all

    render layout: "admin_portal"
  end
end
