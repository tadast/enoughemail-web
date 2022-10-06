Rails.application.routes.draw do
  root "organizations#index"

  resources :organizations
  resources :filter_rules

  devise_for :user,
    controllers: {
      omniauth_callbacks: "users/omniauth_callbacks"
    }
end
