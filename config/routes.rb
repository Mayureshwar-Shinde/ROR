Rails.application.routes.draw do
  get "avatars/edit"

  apipie
  namespace :api do
    namespace :v1 do
      resources :users
    end
  end

  root 'home#homepage'
  get '/homepage', to: 'home#homepage'

  devise_for :case_managers, controllers: {
    registrations: 'case_managers/registrations',
    sessions: 'case_managers/sessions'
  }
  devise_for :dispute_analysts, controllers: {
    registrations: 'dispute_analysts/registrations',
    sessions: 'dispute_analysts/sessions'
  }

  resource :avatar, only: %i[edit update destroy]

  resources :cases

end
