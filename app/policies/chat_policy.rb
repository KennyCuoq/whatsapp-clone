class ChatPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    true
  end

  def show?
    user.chats.include?(record)
    # Needs to return true if the chat includes messages from current user
  end
end
