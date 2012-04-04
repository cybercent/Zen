class RegistrationsController < Devise::RegistrationsController
  def update
    if resource.update_with_password(params[resource_name])
      sign_in resource, :bypass => true
      redirect_to account_path, :notice => "Password updated."
    else
      clean_up_passwords(resource)
      render "users/password"
    end
  end
end