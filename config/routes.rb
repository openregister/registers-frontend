Rails.application.routes.draw do
  health_check_routes

  root 'pages#home'

  get 'using-registers', to: 'pages#using_registers', as: 'using_registers'
  get 'roadmap', to: 'pages#roadmap', as: 'roadmap'
  get 'services-using-registers', to: 'pages#services_using_registers', as: 'services_using_registers'
  get 'avaliable-registers', to: redirect('/registers', status: 301)
  get 'combining-registers', to: 'pages#combining_registers', as: 'combining_registers'
  get 'case-study-tiscreport', to: 'pages#case_study', as: 'case_study'

  resources :registers, only: %i[show index] do
    resources :entries, path: 'updates', only: :index
  end

  resources :suggest_registers, path: 'suggest-register'

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

  mount Spina::Engine => '/'

  get '/*id' => 'pages#show', as: "page", controller: 'pages', constraints: lambda { |request|
    !(Rails.env.development? && request.env['PATH_INFO'].starts_with?('/rails/') || request.env['PATH_INFO'].starts_with?("/#{Spina.config.backend_path}") || request.env['PATH_INFO'].starts_with?('/attachments/'))
  }

  Spina::Engine.routes.draw do
    namespace :admin do
      resources :registers, except: [:show]
    end
  end
end
