class MenuController < ApplicationController
  before_action :authenticate_user!
  skip_after_action :verify_authorized

  def user_dashboard
  end
end
