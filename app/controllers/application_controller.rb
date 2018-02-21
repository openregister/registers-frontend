class ApplicationController < Spina::ApplicationController
  include Spina::Frontend

  protect_from_forgery with: :exception
end
