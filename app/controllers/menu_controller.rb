class MenuController < ApplicationController
  before_action :authenticate_user!
  skip_after_action :verify_authorized

  def user_dashboard
    @user = current_user
    # Picks up chats that has messages where user is either a recipient or a sender
    @chats = @user.chats
  end
end
