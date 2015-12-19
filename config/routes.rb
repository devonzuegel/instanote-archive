Rails.application.routes.draw do
  resources :users
  root to: 'visitors#index'
  get '/signin'                  => 'sessions#new',      as: :signin
  get '/signout'                 => 'sessions#destroy',  as: :signout
  get '/auth/twitter/callback'   => 'sessions#create'
  get '/auth/failure'            => 'sessions#failure'

  get '/evernote/connect'        => 'evernote#new'
  get '/auth/evernote/callback'  => 'evernote#create'
end
