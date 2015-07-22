class UsersController < ApplicationController

  layout 'portal'


  def index
    @users = User.get_index_data
  end

end
