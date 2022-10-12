Rails.application.routes.draw do
  root "users/sessions#new"

  resources :organizations, except: [:index, :destroy] do
    get :onboarding, on: :collection
    get :not_admin, on: :collection
  end
  resource :common_domain_organization, only: [:show]
  resources :filter_rules, only: [:index, :destroy]
  namespace :users do
    resource :session, only: [:new, :destroy]
  end

  devise_for :users,
    controllers: {
      omniauth_callbacks: "users/omniauth_callbacks"
    }
end
