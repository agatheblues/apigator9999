Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'artists', to: 'artists#index', format: 'json'
  get 'artists/:id', to: 'artists#show', format: 'json', as: :artist

  resources :albums, format: 'json'
end
