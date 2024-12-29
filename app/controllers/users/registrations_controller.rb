class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    new_capability_selection_path
  end

  def after_inactive_sign_up_path_for(resource)
    capability_selection_path
  end
end 