class UsersController < ApplicationController

  layout 'clear'

  before_action :require_login, :except => [:new, :create]

  def new
    @user = User.new
    2.times { @user.addresses.build }
  end

  def create
    swap_city_names_for_ids
    @user = User.new(whitelisted_user_params)
    if @user.save
      assign_shipping_id
      assign_billing_id
      flash[:success] = "New user created! Welcome #{@user.name}"
      redirect_to root_path
    else
      flash.now[:error] = @user.errors.full_messages
      render :new
    end
  end

  before_action :require_current_user, :only => [:edit, :update, :destroy]

  def edit
    current_user.addresses.build
  end

  def update
    @user = current_user
    swap_city_names_for_ids
    if current_user.update(whitelisted_user_params)
      assign_shipping_id
      assign_billing_id
      flash[:success] = "Successfully updated your profile"
      redirect_to root_url
    else
      flash.now[:error] = current_user.errors.full_messages
      render :edit
    end
  end

  def destroy
    if sign_out && current_user.destroy
      flash[:success] = "User #{@user.name} successfully deleted!"
      redirect_to root_path
    else
      flash.now[:danger] = "Failed to delete user. Please try again."
      render :edit
    end
  end

  private

  def whitelisted_user_params
    params.require(:user).permit( :first_name, 
                                  :last_name, 
                                  :email, 
                                  :shipping_id, 
                                  :billing_id,
                                  { :addresses_attributes => [
                                      :street_address,
                                      :city_id,
                                      :state_id,
                                      :zip_code,
                                      :id,
                                      :_destroy ] }
                                  )
  end

  def assign_shipping_id
    # params[:user][:addresses_attributes].each do |address_form, attributes|
    #   @user.shipping_id = attributes[:id]
    # end
    shipping_id = params[:user][:shipping_id]
    if shipping_id == "0" || shipping_id == "on"
      @user.shipping_id = Address.find_by(params[:user][:addresses_attributes]["0"]).id
    else
      @user.shipping_id = shipping_id
    end
  end

  def assign_billing_id
    # params[:user][:addresses_attributes].each do |address_form, attributes|
    #   @user.billing_id = attributes[:id]
    # end
    billing_id = params[:user][:billing_id]
    if billing_id == "0" || billing_id == "on"
      @user.billing_id = Address.find_by(params[:user][:addresses_attributes]["0"]).id
    else
      @user.billing_id = billing_id
    end
  end

  # def shipping_checkbox_selected?
  #   params[:user][:shipping_id] != "0"
  # end

  # def billing_checkbox_selected?
  #   params[:user][:billing_id] != "0"
  # end

  def swap_city_names_for_ids
    params[:user][:addresses_attributes].each do |address_form, attributes|
      attributes[:city_id] = find_or_create_city(attributes[:city_id]).id
    end
  end

  def find_or_create_city(name)
    city = City.find_by_name(name)
    city ? city : City.create({:name => name})
  end

  def require_current_user
    unless current_user == User.find(params[:id])
      flash[:error] = "Access denied!!!"
      redirect_to root_url
    end
  end

end
