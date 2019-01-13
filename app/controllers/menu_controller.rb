class MenuController < ApplicationController
  before_action :authenticate_user!
  skip_after_action :verify_authorized

  def user_dashboard
    @user = current_user
    @chats = Chat.all
    # where("daily_price < ?", params[:filter_price].to_i) if params[:filter_price].present?
    # Client.where(locked: true).or(Client.where(orders_count: [1,3,5]))
    # retrieve all chats where either
            # - chat belongs to user && there are messages associated to this chat
            # – chat has messages that were written by user
  end
end
