class AddressesController < ApplicationController
  def index
    @addresses = Address.all
    render layout: "admin"
  end
  def new
  end
  def show
  end
  def edit
  end
  def update
  end
  def create
  end
end
