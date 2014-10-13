class AdminController < ApplicationController

  def index
    flash.now[:notice] = "This is a test of the emergency flash system. If this had been a real flash, you would have been told what to do and where to go. Have a nice day, and our apologies for any inconvenience."
  end

end
