class ChatsController < ApplicationController
  def show
    @chat = Chat.find(params[:id])
    authorize @chat
    @user = current_user
    @contact = @chat.other_user(@user)
  end
end
