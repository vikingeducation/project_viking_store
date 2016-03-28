class UsersController < ApplicationController
  
  layout 'admin_portal'

  def index
    @column_names = ["ID","Name","Joined","City","State","Orders","Last Order Date", "SHOW", "EDIT", "DELETE"]
    @users = User.all_in_arrays
  end
end