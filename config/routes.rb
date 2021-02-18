Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root 'static_pages#home'
  get '/terms_of_service', to: 'static_pages#terms_of_service'
  get '/privacy_policy', to: 'static_pages#privacy_policy'
  get '/signup', to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users do
    member do
      get :following, :followers
      delete 'destroy_all'
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only:[:new, :create, :edit, :update]
  resources :relationships,       only: [:create, :destroy]
  resources :microposts,          only: [:show,:create, :destroy] do 
    resources :comments,         only: [:create, :destroy]
    resource :likes,                    only:[:create, :destroy]
    collection do
      get 'search'
    end
  end 
  resources :notifications,        only:[:index, :destroy] do
    collection do
      delete 'destroy_all'
    end
  end
end

