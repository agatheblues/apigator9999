Rails.application.routes.draw do
  get 'genres', to: 'genres#index', format: 'json'

  get 'artists', to: 'artists#index', format: 'json'
  get 'artists/:id', to: 'artists#show', format: 'json', as: :artist

  resources :albums, format: 'json'
end
