Rails.application.routes.draw do
  apipie
  devise_for :users
  root 'articles#homepage'
  get '/homepage', to: 'articles#homepage'

  namespace :api do
    namespace :v1 do
      resources :users
    end
  end
end
