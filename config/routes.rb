Rails.application.routes.draw do
  mount Spina::Engine => '/'

  Spina::Engine.routes.draw do
    resources :registers, only: [:show, :index]
    resources :supports

    get '/support', to: 'supports#new', as: 'get_support'

    namespace :admin do
      resources :registers, except: [:show]
    end
  end
end
