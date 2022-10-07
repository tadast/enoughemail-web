Rails.application.routes.draw do
  root "users/sessions#new"

  resources :organizations, except: [:index, :destroy]
  resources :filter_rules, only: [:index, :destroy]
  namespace :users do
    resources :sessions, only: [:new, :destroy]
  end

  devise_for :users,
    controllers: {
      omniauth_callbacks: "users/omniauth_callbacks"
    }
end
