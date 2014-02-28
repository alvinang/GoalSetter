module ApplicationHelper

  def current_user
    return nil if session[:token].nil?
    @current_user ||= User.find_by(token: session[:token])
  end

  def logged_in?
    !!current_user
  end

end
