class AddressesController < ApplicationController

  layout 'portal'


  def index
    @addresses = Address.get_index_data
  end

end
