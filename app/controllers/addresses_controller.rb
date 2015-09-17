class AddressesController < ApplicationController
  def index
    @addr = Address.all.order("street_address")
  end
end
