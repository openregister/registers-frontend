Rails.application.routes.draw do
  health_check_routes
  mount Spina::Engine => '/'

  Spina::Engine.routes.draw do
    resources :registers, only: [:show, :index]
    get '/registers/:id/history', to: 'registers#history', as: 'history'

    # Support

    get 'support', to: 'support#index'
    post 'select_support', to: 'support#select_support'

    get 'support/problem', to: 'support#problem'
    post 'support/problem', to: 'support#create'

    get 'support/question', to: 'support#question'
    post 'support/question', to: 'support#create'

    get 'support/thanks', to: 'support#thanks'

    # Request or suggest register

    get 'new-register', to: 'new_register#index'
    post 'select_request_or_suggest', to: 'new_register#select_request_or_suggest'

    get 'new-register/suggest-register', to: 'new_register#suggest_register'
    post 'new-register/suggest-register', to: 'new_register#create'

    get 'new-register/request-register', to: 'new_register#request_register'
    post 'new-register/request-register', to: 'new_register#create'

    get 'new-register/thanks', to: 'new_register#thanks'

    namespace :admin do
      resources :registers, except: [:show]
    end
  end
end
