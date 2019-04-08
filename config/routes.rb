Rails.application.routes.draw do
  health_check_routes

  root 'pages#home'

  get 'services-using-registers', to: 'pages#services_using_registers', as: 'services_using_registers'
  get 'privacy-notice', to: 'pages#privacy_notice', as: 'privacy_notice'
  get 'cookies', to: 'pages#cookies', as: 'cookies'
  get 'terms-and-conditions', to: 'pages#terms_and_conditions', as: 'terms_and_conditions'
  get 'data-format-changes', to: 'pages#data_format_changes', as: 'data_format_changes'

  scope 'about' do
    root 'pages#about', as: 'about'
    get 'characteristics-of-a-register', to: 'pages#characteristics_of_a_register', as: 'characteristics_of_a_register'
    get 'how-registers-help-government-services', to: 'pages#how_registers_help_government_services', as: 'how_registers_help_government_services'
  end

  resources :sign_up, only: %i[create index], path: 'sign-up-for-updates' do
  end

  get '/sign-up-for-updates/thank-you', to: 'sign_up#thank_you', as: 'sign_up_thank_you'

  resources :category, only: %i[show index], param: :slug
  resources :authority, only: %i[show index], param: :slug, path: 'organisations'

  resources :registers, only: %i[show index] do
    resources :entries, path: 'updates', only: :index
    resources :fields, only: :show
    resources :records, constraints: { id: /.*/ }, only: :show

    get '/download-csv', to: 'download#download_csv', as: 'download_csv'
    get '/download-ods', to: 'download#download_ods', as: 'download_ods'

    get '/help-us-improve-the-api', to: 'download#help_improve', as: 'help_improve_api'
    get '/help-us-improve', to: 'download#help_improve', as: 'help_improve_download'

    get '/download', to: 'download#download'
    post '/download', to: 'download#download'

    get '/use-the-api', to: 'download#api'
    post '/use-the-api', to: 'download#api'
  end

  get 'registers-in-progress', to: redirect('/registers', status: 301)

  resources :api_users, path: 'create-api-key'

  # Support
  get 'support', to: 'support#index'
  post 'select_support', to: 'support#select_support'

  get 'support/problem', to: 'support#problem'
  post 'support/problem', to: 'support#create'

  get 'support/question', to: 'support#question'
  post 'support/question', to: 'support#create'

  get 'support/thanks', to: 'support#thanks'

  # Suggest a register
  get 'suggest-new-register', to: 'suggest_a_register#index'
  post 'suggest-new-register', to: 'suggest_a_register#check'
  get 'suggest-new-register/complete', to: 'suggest_a_register#complete'

  resource :sitemap, only: :show

  # Legacy URL's so we dont break users
  get 'suggest-register', to: redirect('/support', status: 301)
  get 'request-register', to: redirect('/support', status: 301)
  get 'new-register', to: redirect('/support', status: 301)
  get 'new-register/request-register', to: redirect('/support', status: 301)
  get 'new-register/suggest-register', to: redirect('/support', status: 301)
  get 'api_users/new', to: redirect('/create-api-key', status: 301)
  get 'avaliable-registers', to: redirect('/registers', status: 301)
  get 'combining-registers', to: redirect('about', status: 301)
  get 'using-registers', to: redirect('about', status: 301)
  get 'case-study-tiscreport', to: redirect('services-using-registers', status: 301)

  get '404', to: 'errors#not_found'
  get '500', to: 'errors#internal_server_error'
end
