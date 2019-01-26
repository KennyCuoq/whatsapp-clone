class SessionsController < Devise::SessionsController
  def destroy
    current_user.status = Time.now
    current_user.save!
    super
  end
end
