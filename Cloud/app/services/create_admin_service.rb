class CreateAdminService
  def call
    Admin.find_or_create_by!(firstname: 'admin', lastname: 'user') do |user|
      user.email = Figaro.env.admin_username
      user.password = Figaro.env.admin_password
      user.password_confirmation = Figaro.env.admin_password
      user.skip_confirmation!
    end
  end
end
