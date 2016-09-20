module UsersHelper

  def cart(user)
    if has_cart?(user)
      user.orders.find_by(:checkout_date => nil)
    else
      nil
    end
  end

  def submit(form_type, object)
    "#{(form_type == "Edit" ? "Update" : form_type)} #{object}"
  end
end
