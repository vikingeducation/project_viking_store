module AddressesHelper
  def index_address_create(user)
    if user
      (link_to "Create Address for #{user.name}", new_user_address_path(user), :class => "btn btn-block btn-default btn-lg btn-primary")
    else
      raw("<em>Create new addresses from within #{(link_to 'User', users_path)} profiles </em>")
    end
  end
end
