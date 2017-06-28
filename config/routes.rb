Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", confirmations: "users/confirmations" }, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', edit: 'profile' }

  resources :topics do
    post :like, on: :member
  end

  resources :portfolios, except: [:show] do
    put :sort, on: :collection
    post :like, on: :member
  end

  get 'portfolio/:id', to: 'portfolios#show', as: 'portfolio_show'
  get 'portfolios/angulars', to: 'portfolios#angular', as: 'portfolio_angular'

  resources :blogs do
    member do
      get :toggle_status
      post :like
    end
  end

  post 'comment/:id/like', to: 'comments#like', as: 'like_comment'
  delete 'comment/:id', to: 'comments#destroy', as: 'delete_comment'

  get '/about-me', to: 'pages#about'
  get '/tech-news', to: 'pages#tech_news'

  mount ActionCable.server => '/cable'

  root to: 'pages#home'

  namespace :api, defaults: {format: :json} do
    devise_scope :user do
      mount_devise_token_auth_for 'User', at: 'auth'

      resources :topics do
        post :like, on: :member
      end

      resources :blogs do
        member do
          get :toggle_status
          post :like
        end
      end
    end
  end
end
