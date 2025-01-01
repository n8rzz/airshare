class Users::SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate!(auth_options)
    
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    
    if turbo_frame_request?
      render turbo_stream: turbo_stream.redirect(after_sign_in_path_for(resource))
    else
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end
end 