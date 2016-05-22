module ApplicationHelper
  def set_active(cname, aname)
    "active" if controller_name == cname && action_name == aname
  end
end
