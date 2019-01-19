class MessagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:home]
  skip_after_action :verify_authorized, only: [:create]


  def create
    # binding.pry
    if message_params[:content]
      @message = Message.new(content: message_params[:content])
    else
      @message = Message.new(content: "Yay! It's the start of your conversation with")
    end
    # IF USER ALREAYD HAS A CHAT WITH THAT PERSON, REDIRECT THEM TO THAT CHAT
    if message_params[:chat_id]
      @chat = Chat.find(message_params[:chat_id])
    else
      @chat = Chat.create
    end
    # binding.pry
    @message.chat = @chat
    if message_params[:recipient_id]
      @message.recipient = User.find(message_params[:recipient_id])
    else
      @message.recipient = User.find_by_username(message_params[:recipient])
    end
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
    params.require(:message).permit(:content, :recipient_id, :recipient, :chat_id)
  end

  def comes_from_menu
  end

  def comes_from_chat
  end
end
