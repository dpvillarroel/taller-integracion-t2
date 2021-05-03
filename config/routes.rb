Rails.application.routes.draw do
  
  resources :artists, only: [:create,:index,:show,:destroy] do
    resources :albums, only: [:create, :index]
    resources :tracks, only:  [:index]
  end
  resources :albums, only: [:index,:show,:destroy] do
    resources :tracks, only: [:create, :index]
  end
  resources :tracks, only: [:index,:show,:destroy]
  put 'artists/:id/albums/play', to: 'artists#play'
  put 'albums/:id/tracks/play', to: 'albums#play'
  put 'tracks/:id/play', to: 'tracks#play'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
