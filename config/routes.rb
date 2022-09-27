Rails.application.routes.draw do
  root "organizations#index"

  resources :organizations

  devise_for :user,
    controllers: {
      omniauth_callbacks: "users/omniauth_callbacks"
    }
end
