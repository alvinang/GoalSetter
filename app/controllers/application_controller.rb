class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ApplicationHelper

  def login!(user)
    session[:token] = user.reset_token!
  end

  def logout!
    current_user.reset_token!
    session[:token] = nil
  end

end
