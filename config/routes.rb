Rails.application.routes.draw do
  resources :artists, :albums, :genres
end
