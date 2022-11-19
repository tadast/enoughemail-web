Rails.application.routes.draw do
  resources :filter_rule_templates, except: [:destroy]
  root "users/sessions#new"

  resources :organizations, except: [:index, :destroy] do
    get :onboarding, on: :collection
    get :not_admin, on: :collection
  end
  resources :organization_credentials_tests, only: [:show, :create]
  resource :common_domain_organization, only: [:show]
  resources :filter_rules, only: [:index, :destroy]
  resources :users, only: [:index]
  resources :gmail_users, only: [:index]
  namespace :users do
    resource :session, only: [:new, :destroy]
  end

  devise_for :users,
    controllers: {
      omniauth_callbacks: "users/omniauth_callbacks"
    }
end
