# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'home#index', format: 'json'

  # Users
  get '/users/current', to: 'users#current', format: 'json'
  resources :users, format: 'json', only: %I[index create update destroy]

  # Get login token from Knock
  post 'user_token', to: 'user_token#create'

  # Genres and Styles
  get 'genres', to: 'genres#index', format: 'json'
  get 'styles', to: 'styles#index', format: 'json'

  # Artists
  resources :artists, format: 'json', only: %I[index show update]
  post 'artists/:id1,:id2', to: 'artists#merge', format: 'json'

  # Albums
  resources :albums, format: 'json'

  # Batches
  get 'batches/:id', to: 'batches#show', format: 'json'
  post 'batches', to: 'batches#create', format: 'json'

  mount Sidekiq::Web => '/sidekiq' if Rails.env.development?
end
