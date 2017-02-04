class AddressesController < ApplicationController

	include AddressesHelper

	def index
		
		if params[:user_id]
			@filtered_address = true
			if User.all.ids.include? params[:user_id].to_i
				@user = User.find(params[:user_id])
				@addresses = @user.addresses
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
		@address = User.find(params[:user_id]).addresses.build()
	end

	def create
		@address = Address.find(params[:id])
		@address.street_address = params[:street_address]
		@address.secondary_address = params[:secondary_address]
		@address.zip_code = params[:zip_code]
		@address.city_id = params[:city_id]
		@address.state_id = params[:state_id]
		puts "printing params hash"
		p params
		if @address.save
			flash[:success] = "Address created successfully"
			render action: "index"
		else
			flash[:error] = "Address creation failed"
			render action: "new"
		end
	end

	def edit
		@address = Address.find(params[:id])
	end

	def update

	end

	def destroy

	end
	
end
