Rails.application.routes.draw do

  get '/sendfeedback' => 'send_feedback#index'
  post '/sendfeedback' => 'send_feedback#createTicket'

  mount Spina::Engine => '/'

  Spina::Engine.routes.draw do
    resources :registers, only: [:show, :index]

    namespace :admin do
      resources :registers, except: [:show]
    end
  end
end
