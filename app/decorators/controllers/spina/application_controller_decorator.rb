Spina::ApplicationController.class_eval do
  http_basic_authenticate_with name: ENV["HTTP_AUTH_USERNAME"], password: ENV["HTTP_AUTH_PASSWORD"] if Rails.env.production?
end
