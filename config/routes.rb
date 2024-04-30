Rails.application.routes.draw do
  root to: 'toppages#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :create, :edit, :update, :new] do
    member do
      get :followings
      get :followers
      get :favorites
    end
    collection do
      get :search
    end
  end

  resources :microposts, only: [:new, :create, :index, :show, :destroy] do
    resources :favorites, only: [:create, :destroy]
  end

  resources :relationships, only: [:create, :destroy]
  resources :favorites, only: [:create, :destroy]
end