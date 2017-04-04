Rails.application.routes.draw do
  mount Spina::Engine => '/'

  Spina::Engine.routes.draw do
    resources :registers, only: [:show, :index]

    get 'support', to: 'support#index'
    post 'select_support', to: 'support#select_support'

    get 'support/problem', to: 'support#problem'
    post 'support/problem', to: 'support#create'

    get 'support/question', to: 'support#question'
    post 'support/question', to: 'support#create'

    get 'support/thanks', to: 'support#thanks'

    namespace :admin do
      resources :registers, except: [:show]
    end
  end
end
