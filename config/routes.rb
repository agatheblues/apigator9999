# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index', format: 'json'

  # Users
  get '/users/current', to: 'users#current', format: 'json'
  post '/users', to: 'users#create', format: 'json'
  patch '/users/:id', to: 'users#update', format: 'json'
  delete '/users/:id', to: 'users#destroy', format: 'json'

  # Get login token from Knock
  post 'user_token', to: 'user_token#create'

  # Genres and Styles
  get 'genres', to: 'genres#index', format: 'json'
  get 'styles', to: 'styles#index', format: 'json'

  # Artists
  get 'artists', to: 'artists#index', format: 'json'
  get 'artists/:id', to: 'artists#show', format: 'json', as: :artist
  post 'artists/:id1,:id2', to: 'artists#merge', format: 'json'

  # Albums
  resources :albums, format: 'json'
end
