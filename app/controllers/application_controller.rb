class ApplicationController < Spina::ApplicationController
  include Spina::Frontend

  http_basic_authenticate_with name: ENV['HTTP_AUTH_USERNAME'], password: ENV['HTTP_AUTH_PASSWORD'] if Rails.env.production?

  protect_from_forgery with: :exception

private

  def current_user
    @current_user ||= User.where(id: session[:user_id]).first if session[:user_id]
  end
  helper_method :current_user
end
