Rails.application.routes.draw do
  # ARTISTS
  get "/artists", to: "artists#index"
  post "/artists", to: "artists#create"
  get "/artists/:id", to: "artists#show"
  patch "/artists/:id", to: "artists#update"
  delete "/artists/:id", to: "artists#destroy"

  # ALBUMS
  get "/albums", to: "albums#index"
  post "/albums", to: "albums#create"
  get "/albums/:id", to: "albums#show"
  patch "/albums/:id", to: "albums#update"
  delete "/albums/:id", to: "albums#destroy"
end
