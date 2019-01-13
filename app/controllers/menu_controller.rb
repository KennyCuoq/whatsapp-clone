class MenuController < ApplicationController
  before_action :authenticate_user!
  skip_after_action :verify_authorized

  def user_dashboard
    @user = current_user
    # retrieve all chats where either
            # - chat belongs to user && there are messages associated to this chat
            # – chat has messages that were written by user


            # add association
  end
end
