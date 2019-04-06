Rails.application.routes.draw do
  resources :artists, only: [:index, :create, :show, :update, :destroy]
  resources :albums, only: [:index, :create, :show, :update, :destroy]
end
