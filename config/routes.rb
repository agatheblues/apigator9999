Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'artists', to: 'artists#index', format: 'json'

  # Albums
  get 'albums', to: 'albums#index', format: 'json'
  get 'albums/:id', to: 'albums#show', format: 'json', as: :album
end
