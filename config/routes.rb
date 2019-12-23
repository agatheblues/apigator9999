Rails.application.routes.draw do
  root to: "home#index", format: 'json'

  # Users
  get '/users', to: 'users#index', format: 'json'
  get '/users/current', to: 'users#current', format: 'json'
  post '/users/create', to: 'users#create', format: 'json'
  patch '/user/:id', to: 'users#update', format: 'json'
  delete '/user/:id', to: 'users#destroy', format: 'json'

  # Get login token from Knock
  post 'user_token', to: 'user_token#create'

  # Genres and Styles
  get 'genres', to: 'genres#index', format: 'json'
  get 'styles', to: 'styles#index', format: 'json'

  # Artists
  get 'artists', to: 'artists#index', format: 'json'
  get 'artists/:id', to: 'artists#show', format: 'json', as: :artist

  # Albums
  resources :albums, format: 'json'
end
