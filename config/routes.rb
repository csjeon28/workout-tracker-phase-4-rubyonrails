Rails.application.routes.draw do
  resources :users
  resources :workouts
  resources :exercises

  get '/me', to: 'users#show'

  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
