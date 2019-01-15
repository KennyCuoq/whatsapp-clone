class MenuController < ApplicationController
  before_action :authenticate_user!
  skip_after_action :verify_authorized

  def user_dashboard
    # @test = Chat.first.messages
    @user = current_user
    # Picks up chats that has messages where user is either a recipient or a sender
    @chats = Chat.including(@user)
    # test
    @chats = @chats.sort_by { |chat| chat.last_message.created_at }.reverse
    # I feel this query can be rewritten in a more efficient way
  end
end
