Rails.application.routes.draw do
  root 'pages#show'
  devise_for :users
  resources :users, only: [:show]
  resources :locations, only: [:index, :create]
end
