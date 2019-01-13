class MenuController < ApplicationController
  before_action :authenticate_user!
  skip_after_action :verify_authorized

  def user_dashboard
    @user = current_user
    # Picks up chats where user has participated
    chats_one = Chat.includes(:messages).where(messages: {user_id: @user})
    # Picks up chats where user has been sent messages but has not yet participated
    chats_second = Chat.where("user_id = ?", @user).reject {|chat| chat.messages.empty?}
    # Concatenates both above results
    @chats = (chats_one + chats_second).uniq
    # Order results from most recent chat to oldest
    @chats = @chats.sort_by { |chat| chat.updated_at}.reverse!
    # ABOVE LINES NEED TO BE REFACTORED WITH A SMARTER EXHAUSTIVE QUERY
  end
end
