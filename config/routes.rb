Rails.application.routes.draw do
  root "home#homepage"
  devise_for :users, controllers: { registrations: 'users/registrations' }
end
