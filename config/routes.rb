Rails.application.routes.draw do
  root 'pages#show'
  devise_for :users
  resources :users, only: [:show]
  resources :friends, only: [:create, :destroy]
  resources :locations, except: :destroy
  resources :location_users, only: [:destroy]
  get '/user_friends', to: 'users#friends'
  get '/search_users', to: 'users#search'
end
