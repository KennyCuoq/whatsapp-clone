class MenuController < ApplicationController
  before_action :authenticate_user!
  skip_after_action :verify_authorized

  def user_dashboard
    @user = current_user
    # retrieve all chats where user
  end
end
