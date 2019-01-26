class SessionsController < Devise::SessionsController
  def destroy
    current_user.status = Time.now
    current_user.save!
    current_user.broadcast_status
    super
  end
end
