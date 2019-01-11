class MenuController < ApplicationController
  before_action :authenticate_user!

  def user_dashboard
  end
end
