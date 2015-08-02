module UsersHelper

  def edit_button_title
    if signed_in_user?
      "Update User Info"
    else
      "Complete Sign Up"
    end
  end


  def edit_button_text
    if signed_in_user?
      "Submit Changes"
    else
      "Sign Up"
    end
  end

end
