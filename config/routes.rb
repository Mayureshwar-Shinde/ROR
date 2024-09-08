Rails.application.routes.draw do
  get "avatars/edit"
  root "home#homepage"

  # user with devise
  devise_for :users, controllers: { registrations: 'users/registrations' }

  # avatar
  resource :avatar, only: [:edit, :update, :destroy]
end
