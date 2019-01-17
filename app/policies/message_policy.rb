class MessagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end

    def create?
      @user.nil?
    end
  end
end
