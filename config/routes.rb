Rails.application.routes.draw do

  apipie

  root 'articles#homepage'
  get '/homepage', to: 'articles#homepage'
  get '/analytics', to: 'articles#analytics', as: 'analytics'

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
    get 'audits/index'
    get 'audits/show_users'
    get 'audits/show_avatars'
    get 'audits/show_cases'
    get 'audits/show_notes'
    get 'audits/show_appointments'
    get 'audits/show_communication'
    get '/avatars/new', to: 'avatars#new', as: 'new_avatar'
    put '/avatars/create', to: 'avatars#create', as: 'update_avatar'
    delete '/avatars/destroy', to: 'avatars#destroy', as: 'delete_avatar'
    resources :cases do
      resources :notes
      resources :appointments
      member do
        resources :communications
      end
    end
    get '/my_appointments', to: 'appointments#my_appointments', as: 'my_appointments'
    get '/audits/index', to: 'audits#index', as: 'audit_index'
    get '/audits/show', to: 'audits#show', as: 'audit_show'
  end

  namespace :dispute_analysts do
    get '/avatars/new', to: 'avatars#new', as: 'new_avatar'
    put '/avatars/create', to: 'avatars#create', as: 'update_avatar'
    delete '/avatars/destroy', to: 'avatars#destroy', as: 'delete_avatar'
    resources :cases do
      resources :notes
      resources :appointments
      member do
        resources :communications
      end
    end
    get '/my_appointments', to: 'appointments#my_appointments', as: 'my_appointments'
  end

end
