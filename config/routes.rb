Rails.application.routes.draw do

  apipie

  root 'articles#homepage'
  get '/homepage', to: 'articles#homepage'

  namespace :api do
    namespace :v1 do
      resources :users
    end
  end

  devise_for :case_managers, controllers: {
    registrations: 'case_managers/registrations',
    sessions: 'case_managers/sessions'
  }

  devise_for :dispute_analysts, controllers: {
    registrations: 'dispute_analysts/registrations',
    sessions: 'dispute_analysts/sessions'
  }

  namespace :case_managers do
    get '/avatars/new', to: 'avatars#new', as: 'new_avatar'
    put '/avatars/create', to: 'avatars#create', as: 'update_avatar'
    delete '/avatars/destroy', to: 'avatars#destroy', as: 'delete_avatar'
    resources :cases do
      resources :notes
      resources :appointments
    end
    get '/my_appointments', to: 'appointments#my_appointments', as: 'my_appointments'
  end

  namespace :dispute_analysts do
    get '/avatars/new', to: 'avatars#new', as: 'new_avatar'
    put '/avatars/create', to: 'avatars#create', as: 'update_avatar'
    delete '/avatars/destroy', to: 'avatars#destroy', as: 'delete_avatar'
    resources :cases do
      resources :notes
      resources :appointments
    end
    get '/my_appointments', to: 'appointments#my_appointments', as: 'my_appointments'
  end

end
