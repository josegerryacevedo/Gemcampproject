Rails.application.routes.draw do
  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    root to: 'users/home#index', as: :client_root
    namespace :users do
      get 'lottery', to: 'lotteries#lottery'
      get 'invite-people', to: 'invite_people#invite_qr'
      resource :profile
      resources :addresses
    end
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admins, path: '' do
      root to: 'home#index', as: :admin_root
      devise_for :users, controllers: { sessions: 'admins/sessions' }
      resources :users
      resources :items
      resources :categories
    end
  end
end
