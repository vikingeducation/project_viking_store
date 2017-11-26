class Admin::AddressesController < ApplicationController

  layout 'admin_portal_layout'

  def index
    @addresses = Address.all
  end
  
end
