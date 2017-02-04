class AddressesController < ApplicationController

	include AddressesHelper

	def index
		if params[:user_id]
			@filtered_address = true
			if User.all.ids.include? params[:user_id].to_i
				@user = User.find(params[:user_id])
				@addresses = @user.addresses.order(:id)
			else
				flash[:error] = "Bad user id! Showing all addresses"
				@filtered_address = false
				@addresses = Address.order(:id)
			end
		else
			@filtered_address = false
			@addresses = Address.order(:id)
		end
	end

	def show
		@address = Address.find(params[:id])
	end

	def new
		@user = User.find(params[:user_id])
		@address = Address.new
	end

	def create
		@user = User.find(params[:user_id])
		@address = @user.addresses.build(addresses_params)
		if @address.save
			flash[:success] = "Address created successfully"
			redirect_to user_addresses_path(@user.id)
		else
			flash[:error] = "Address creation failed"
			render action: "new"
		end
	end

	def edit
		@address = Address.find(params[:id])
	end

	def update
		@address = Address.find(params[:id])
		if @address.update(addresses_params)
			flash[:success] = "Great! Your address has been updated!"
			redirect_to address_path(@address.id)
		else
			flash[:error] = "Could not update!"
			render action: "edit"
		end
	end

	def destroy
		@address = Address.find(params[:id])
		if @address.destroy
			flash[:success] = "Great! Your address has been removed!"
			redirect_to addresses_path
		else
			flash[:error] = "Could not remove user!"
			redirect_to(:back)
		end
	end
	
end
