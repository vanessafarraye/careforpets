Rails.application.routes.draw do

  root to: "welcome#index"

  get "/welcome", to: "welcome#index"
  
  resources :users, except: [:new]
  get "/account", to: 'users#show'

  resources :clients do
    resources :donations
  end

  post "/sessions", to: "sessions#create"
  get "/sessions", to: "sessions#destroy"
end