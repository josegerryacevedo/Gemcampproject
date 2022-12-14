Rails.application.routes.draw do
  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
    root to: 'users/home#index', as: :client_root
    namespace :users do
      get 'invite-people', to: 'invite_people#invite_qr'
      resources :winners, only: [:show, :update]
      resources :shares, only: [:show, :update]
      resource :profile
      resources :addresses
      resources :lotteries
      resources :share_feedbacks, path: 'share', only: [:index, :show]
      resources :offers, path: 'shop', only: :index do
        post :order
      end
      scope :orders, path: 'orders', as: 'orders' do
        put "cancel/:order_id", to: 'orders#cancel'
      end
    end
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admins, path: '' do
      root to: 'home#index', as: :admin_root
      devise_for :users, controllers: { sessions: 'admins/sessions' }
      resources :users do
        resources :increases, path: 'orders/increase', only: [:create, :new]
        resources :deductions, path: 'orders/deduct', only: [:create, :new]
        resources :bonuses, path: 'orders/bonus', only: [:create, :new]
      end
      resources :items do
        put :start, :pause, :cancel, :end
      end
      resources :categories
      resources :bets, only: :index do
        put :cancel
      end
      resources :winners, only: :index do
        put :submit, :pay, :ship, :deliver, :publish, :remove_publish
      end
      resources :offers
      resources :orders, only: :index do
        put :pay, :cancel
      end
      resources :invite_lists, only: :index
      resources :news_tickers, except: :show
      resources :banners, except: :show
    end
  end
end
