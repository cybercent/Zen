class ApplicationController < ActionController::Base
  protect_from_forgery
  
  layout :layout_by_resource
  
  def layout_by_resource
    if user_signed_in?
      "application"
    else
      "site"
    end
  end
  
  def after_sign_in_path_for(resource_or_scope)
    case resource_or_scope
    when :user, User
       projects_path
    else
      super
    end
  end
end
