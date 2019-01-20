class MessagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:home]
  skip_after_action :verify_authorized, only: [:create]


  def create
    # binding.pry
    if comes_from_chat_show
      @message = Message.new(content: message_params[:content])
      @chat = Chat.find(message_params[:chat_id])
      @message.recipient = User.find(message_params[:recipient_id])
    else
      @message = Message.new(content: "Hey there! I am using WhatsUpp.")
      @chat = Chat.create
      @message.recipient = User.find_by_username(message_params[:recipient])
    end
    @message.chat = @chat
    @message.sender = current_user
    if @message.save
      respond_to do |format|
        format.html { redirect_to chat_path(@chat) }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    end
    # NEED TO FIGURE OUT HOW TO SET UP PUNDIT FOR THIS, KEEP GETTING 'not allowed to create?'
    # authorize @message
  end

  private

  def message_params
    params.require(:message).permit(:content, :recipient_id, :chat_id, :recipient)
  end

  def comes_from_chat_show
    message_params[:content].present? && message_params[:chat_id].present? && message_params[:recipient_id].present?
  end
end
