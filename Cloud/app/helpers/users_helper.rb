module UsersHelper
  def create_user_path(user)
    if user.standard_user?
      unit_users_path(user.unit)
    else
      users_path
    end
  end
end
