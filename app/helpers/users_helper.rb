module UsersHelper
  def name_or_email(user)
    user.username || user.email
  end
end
