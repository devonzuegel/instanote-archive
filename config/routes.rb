Rails.application.routes.draw do
  resources :users
  root to: 'visitors#index'

  get '/auth/failure'             => 'sessions#failure'

  get '/signin'                   => 'sessions#new',      as: :signin
  get '/signout'                  => 'sessions#destroy',  as: :signout
  get '/auth/twitter/callback'    => 'sessions#create'

  get '/evernote/connect'         => 'evernote#new'
  get '/auth/evernote/callback'   => 'evernote#create'

  get '/instapaper/connect'       => 'instapaper#new'
  get '/auth/instapaper/callback' => 'instapaper#create'
end
