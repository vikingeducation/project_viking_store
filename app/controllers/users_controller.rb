class UsersController < ApplicationController

  layout 'front_facing'

  def create
    add_city_id_to_params
    @user = User.new(whitelisted_params)
    # I was thinking if we save the user then the addresses will save as well and therefore their ids will be available. 
    # Also at this time the params will be available, so if we can have the params store the the address key as the user's billiing_id and shipping_id, we could solve it from that, so first I have to get the radio buttons to send the index as the value.
    if @user.save
      # at this point the addresses will have been saved or the user doesn't have any addresses...

      # Situations with default addresses with new users.
      # 1 - User creates an address and chooses the correct default - Code below should go without a hitch.
      # 2 - User creates an address in address 1 but then clicks on defaults for the second address where the address hasn't been created - Code below will set the user's billing_id and shipping_id to nil, which is also fine.
      # 3 - User creates an address in address 2 but then clicks on defaults for the first address where the address hasn't been created - Code below will set the user's billing_id and shipping_id to the other created addresses id....
      # 4 - User creates an address in address 2 and clicks on defaults for this address but address 1 doesn't get, created - user's billling_id and shipping_id will get set to nil.
      # Considering all the problems happen when only one address is created, to make it easy for myself, I'll just make it that if the size is == 1 then this users billing_id and shipping_id are that one addresses id.
      set_new_user_default_addresses(@user)
      # Now that we've created, we are gonna sign in using method from application controlle.
      sign_in(@user)

      flash[:notice] = "Your account has been created."
      redirect_to root_path
    else
      flash.now[:alert] = "Account could not be created..."
      render :new
    end
  end

  def destroy
    sign_out
    User.find(params[:id]).destroy
      flash[:notice] = "Your account has been destroyed and you have been signed out!"
      redirect_to root_path
  end

  def edit
    # It should not be possible to edit the information of anyone who isn't the current_user.
    # could just redirect the user back to the root_path if the current_user.id != params[:id]
    if current_user.id == params[:id].to_i
      @user = User.find(params[:id])
      @user.addresses.build
    else
      flash[:notice] = "Sorry, you can only edit your own account. Current user #{session[:current_user_id]}"
      redirect_to root_path
    end
  end

  def new
    @user = User.new
    @user.addresses.build
    @user.addresses.build
  end

  def update
    @user = User.find(params[:id])
    add_city_id_to_params
    old_address_ids = @user.addresses.ids
    if @user.update_attributes(whitelisted_params)
      update_users_default_addresses(@user, old_address_ids)
      flash[:notice] = "Your account has been updated."
      redirect_to root_path
    else
      flash.now[:alert] = "Could Not Update User. Attribute Issues Probably."
      render(:edit)
    end
  end

  private

  def add_city_id_to_params
    # All the addresses keys are from 0 upwards which means we could iterate with a .times enumerator pretty easy
    params["user"]["addresses_attributes"].size.times do |x| 
      # This will return the city that was entered for the address with x as the key.
      # Now I want to run that through the City class method that returns an id.
      address = params["user"]["addresses_attributes"][x.to_s]
      # Making sure that we're not inserting a city_id when the user hasn't entered anything.
      if address["city"].strip.length > 0
        city_id = City.name_to_id(address["city"].strip)
        # Entering that into the address city_id
        address[:city_id] = city_id
      end
    end
  end

  # if the user's billing_id || shipping_id is = 0 we gotta take full effect.
  # Before the update, the user will have a bunch of addresses with ids
  # after the update, the user will have a bunch of addresses with ids
  # new ids - old ids will give us an array that contains only a newly built addresses id.
  # If there's no id left over, we'll set the 0 to nil.
  def update_users_default_addresses(user, old_address_ids)
    new_id = (user.addresses.ids - old_address_ids).first
    if user.billing_id == 0
      if new_id == nil
        user.billing_id = nil
      else
        user.billing_id = new_id
      end
    end

    if user.shipping_id == 0
      if new_id == nil
        user.shipping_id = nil
      else
        user.shipping_id = new_id
      end
    end
    user.save
  end

  def set_new_user_default_addresses(user)
    # If no addresses were create with this user...
    if user.addresses.size == 0
      user.billing_id = nil
      user.shipping_id = nil
    elsif user.addresses.size == 1
      user.billing_id = user.addresses.first.id
      user.shipping_id = user.addresses.first.id
    else
      # These bits of code won't run if user hasn't chosen any defaults.
      # Note the && user.billing_id != nil - Has to be there because nil.to_i == 0
      user.billing_id = user.addresses[user.billing_id.to_i].id if user.addresses[user.billing_id.to_i] && user.billing_id != nil
      
      user.shipping_id = user.addresses[user.shipping_id.to_i].id if user.addresses[user.shipping_id.to_i] && user.shipping_id != nil
    end
    user.save
  end

  def whitelisted_params
    # Hopefully i can just require and permit this now...
    params.require(:user).permit(:billing_id, :shipping_id, :email, :first_name, :last_name, :addresses_attributes => [:id, :street_address, :state_id, :zip_code, :city_id, :_destroy])
  end

end
