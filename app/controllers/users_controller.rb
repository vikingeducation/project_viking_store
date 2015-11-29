class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  before_action :check_user, except: [:new, :create]

  def new
    @user = User.new
    build_blank_address
  end


  def create
    @user = User.new(user_params)
    if @user.save
      update_default_addresses
      sign_in(@user)
      flash[:success] = "Welcome to the Viking Store, #{@user.first_name.capitalize}"
      redirect_to root_path
    else
      build_blank_address
      flash.now[:danger] = "Oops, something went wrong!"
      render :new
    end
  end


  def edit
    @user = User.find_by_id(params[:id])
    build_blank_address
  end


  def update
    @user = User.find_by_id(params[:id])
    if @user.update(user_params)
      update_default_addresses
      flash[:success] = "Profile Updated"
      redirect_to root_path
    else
      build_blank_address
      flash.now[:danger] = "Oops, something went wrong!"
      render :edit
    end
  end


  def destroy
    @user = User.find_by_id(params[:id])
    if @user.destroy
      flash[:warning] = "Sorry to see you go!"
      redirect_to root_path
    else
      flash[:danger] = "You can't leave, she won't let you. . ."
      redirect_to root_path
    end
  end


  private


  def check_user
    unless User.find_by_id(params[:id]) == current_user
      flash[:danger] = "Oops, something went wrong!"
      redirect_to root_path
    end
  end

  # We want to make sure to build blank addresses where needed, so the forms
  # render correctly.  We also want to show two on new sign-up or if user is 
  # editting their profile AND they have no saved addresses.  If their editting
  # and have saved addresses, only show one.  Complicated!
  def build_blank_address
    new_count = @user.addresses.select(&:new_record?).size
    saved_count = @user.addresses.select(&:persisted?).size

    if @user.new_record?
      if new_count == 0
        2.times { blank_address }
      else
        (2 - new_count).times { blank_address }
      end
    else
      if saved_count == 0 && new_count == 0
        2.times { blank_address }
      elsif new_count == 0
        blank_address
      end
    end
  end


  def blank_address
    address = @user.addresses.build
    address.build_city
    address.build_state
  end


  def update_default_addresses
    s_id = params["default_shipping"]
    b_id = params["default_billing"]

    if user_params[:addresses_attributes] && s_id
      shipping = user_params[:addresses_attributes][s_id]["street_address"]
      @user.default_shipping_address = @user.addresses.find_by_street_address(shipping)
      @user.save
    end

    if user_params[:addresses_attributes] && b_id
      billing = user_params[:addresses_attributes][b_id]["street_address"]
      @user.default_billing_address = @user.addresses.find_by_street_address(billing)
      @user.save
    end
  end


  def user_params
    params.require(:user).permit( :email, 
                                  :email_confirmation,
                                  :first_name, 
                                  :last_name, 
                                  :phone, 
                                  :_destroy, 
                                  addresses_attributes: 
                                  [  :id,
                                     :street_address, 
                                     :secondary_address, 
                                     :state_id,
                                     :zip_code, 
                                     :_destroy, 
                                     city_attributes: 
                                     [  :name  ] ] )
  end


end