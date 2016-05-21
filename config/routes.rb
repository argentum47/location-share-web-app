Rails.application.routes.draw do
  root 'pages#show'
  devise_for :users
  resources :users, only: [:show]
  resources :friends, only: [:create, :destroy]
  resources :locations, only: [:index, :create]
end
