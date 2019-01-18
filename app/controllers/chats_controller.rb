class ChatsController < ApplicationController
  def show
    @chat = Chat.find(params[:id])
    authorize @chat
    @user = current_user
    @contact = @chat.other_user(@user)
    # Makes user's unseen messages seen
    @chat.messages_unseen_by(@user).each  do |message|
      message.seen = true
      message.save
    end
  end
end
