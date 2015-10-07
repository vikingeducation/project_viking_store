class AddressesController < ApplicationController
  def index
    @addr = Address.all.order("street_address")
  end

  def edit
    @addr = Address.find(params[:id])
    @user = @addr.user
    @states = state_choices
  end

  def update
  @addr = Address.find(params[:id])
    if @addr.update_attributes(addr_params)
      redirect_to @addr.user
    else
      render 'edit'
    end
  end

  def new
    @addr = Address.new
    @user_id = params[:uid]
    @states = state_choices
  end

  def create

    @addr = Address.new(addr_params)
    if @addr.save
      redirect_to user_path(@addr.user)
    else
      render 'new'
    end

  end

  def destroy
    @addr = Address.find(params[:id])
    @addr.destroy
    redirect_to addresses_path
  end

private
 def addr_params
  params.require(:address).permit(
    :street_address,
    :secondary_address,
    :zip_code,
    :city_id,
    :state_id,
    :user_id,
    :created_at,
    :updated_at
  )
  end

  def User_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :billing_id,
      :shipping_id,
      :created_at,
      :updated_at,
      )
  end

  def state_choices
    sample = []
    num = 1
    State.all.each do |state|
      sample << ["#{state.name} ( #{state.id})", state.id]
      num += 1
    end
    return sample
  end
end
