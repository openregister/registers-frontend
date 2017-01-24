Rails.application.routes.draw do
  mount Spina::Engine => '/'

  Spina::Engine.routes.draw do
    resources :registers, only: [:show, :index]

    namespace :admin do
      resources :registers, except: [:show]
    end
  end
end
