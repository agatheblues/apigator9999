Rails.application.routes.draw do
  # ARTISTS
  get '/artists', to: 'artists#index'
  post '/artists', to: 'artists#create'
  get '/artists/:id', to: 'artists#show'
  put '/artists/:id', to: 'artists#update'
  delete '/artists/:id', to: 'artists#destroy'

  # ALBUMS
  get '/albums', to: 'albums#index'
  post '/albums', to: 'albums#create'
  get '/albums/:id', to: 'albums#show'
  put '/albums/:id', to: 'albums#update'
  delete '/albums/:id', to: 'albums#destroy'

  # ARTIST'S ALBUMS
  get '/artists/:artist_id/albums', to: 'artist_albums#index'
end
