class MessagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:home]
  skip_after_action :verify_authorized, only: [:create]


  def create
    @message = Message.new(content: message_params[:content])
    @chat = Chat.find(params[:chat_id])
    @message.chat = @chat
    @message.recipient = User.find(message_params[:recipient_id])
    @message.sender = current_user
    if @message.save
      respond_to do |format|
        format.html { redirect_to chat_path(@chat) }
        format.js
      end
    else
      respond_to do |format|
        format.html { render "chat_rooms/show" }
        format.js
      end
    end
    # NEED TO FIGURE OUT HOW TO SET UP PUNDIT FOR THIS, KEEP GETTING 'not allowed to create?'
    # authorize @message
  end

  private

  def message_params
    params.require(:message).permit(:content, :recipient_id)
  end
end
