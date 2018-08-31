Rails.application.routes.draw do
  health_check_routes

  root 'pages#home'

  get 'using-registers', to: 'pages#using_registers', as: 'using_registers'
  get 'services-using-registers', to: 'pages#services_using_registers', as: 'services_using_registers'
  get 'combining-registers', to: 'pages#combining_registers', as: 'combining_registers'
  get 'case-study-tiscreport', to: 'pages#case_study', as: 'case_study'
  get 'privacy-notice', to: 'pages#privacy_notice', as: 'privacy_notice'
  get 'cookies', to: 'pages#cookies', as: 'cookies'
  get 'data-format-changes', to: 'pages#data_format_changes', as: 'data_format_changes'

  resources :sign_up, only: %i[create index], path: 'sign-up-for-updates' do
    # collection do
    #   get '/thank-you-for-signing-up', to: 'sign_up#thank_you', as: 'thank_you'
    # end
  end

  get '/sign-up-for-updates/thank-you', to: 'sign_up#thank_you', as: 'sign_up_thank_you'

  resources :registers, only: %i[show index] do
    resources :entries, path: 'updates', only: :index
    resources :fields, only: :show
    resources :download
    resources :feedback, to: 'registers#create_feedback'
    resources :records, constraints: { id: /.*/ }, only: :show

    get '/download-json', to: 'download#download_json', as: 'download_json'
    get '/download-csv', to: 'download#download_csv', as: 'download_csv'

    get '/choose-how-to-access', to: 'download#choose_access', as: 'choose_access'
    get '/help-us-improve-the-api', to: 'download#help_improve', as: 'help_improve_api'
    get '/help-us-improve', to: 'download#help_improve', as: 'help_improve_download'
    get '/use-the-api', to: 'download#get_api', as: 'get_api'
    post '/use-the-api', to: 'download#post_api', as: 'post_api'
  end

  get '/registers-in-progress', to: 'registers#in_progress'

  resources :api_users, path: 'create-api-key'

  # Support
  get 'support', to: 'support#index'
  post 'select_support', to: 'support#select_support'

  get 'support/problem', to: 'support#problem'
  post 'support/problem', to: 'support#create'

  get 'support/question', to: 'support#question'
  post 'support/question', to: 'support#create'

  get 'support/thanks', to: 'support#thanks'

  resource :sitemap, only: :show

  # Legacy URL's so we dont break users
  get 'suggest-register', to: redirect('/support', status: 301)
  get 'request-register', to: redirect('/support', status: 301)
  get 'new-register', to: redirect('/support', status: 301)
  get 'new-register/request-register', to: redirect('/support', status: 301)
  get 'new-register/suggest-register', to: redirect('/support', status: 301)
  get 'api_users/new', to: redirect('/create-api-key', status: 301)
  get 'avaliable-registers', to: redirect('/registers', status: 301)

  get '404', to: 'errors#not_found'
  get '500', to: 'errors#internal_server_error'

  # Admin paths
  namespace :admin, path: '/admin' do
    root to: "registers#index"

    resources :registers, except: [:show] do
      collection do
        patch :sort
      end
    end

    resources :users

    resources :sessions
    get "signin" => "sessions#new"
    get "signout" => "sessions#destroy"

    resources :password_resets
  end
end
