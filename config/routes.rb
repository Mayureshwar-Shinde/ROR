Rails.application.routes.draw do
  apipie
  devise_for :users
  root 'homepage#homepage'
  get '/homepage', to: 'homepage#homepage'

  get '/avatars/new', to: 'avatars#new', as: 'new_avatar'
  put '/avatars/create', to: 'avatars#create', as: 'update_avatar'
  delete '/avatars/destroy', to: 'avatars#destroy', as: 'delete_avatar'

  namespace :api do
    namespace :v1 do
      resources :users
    end
  end
end
