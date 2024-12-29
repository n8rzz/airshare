Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }
  
  namespace :admin do
    root to: 'dashboard#index'
    resources :users do
      collection do
        get :search
        get :admins
        get :regular_users
      end
      member do
        patch :toggle_admin
      end
    end
  end
  
  root "pages#home"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resource :capability_selection, only: [:new, :create], controller: 'capability_selection'
end
