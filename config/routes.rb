Rails.application.routes.draw do
  resources :topics do
    member do
      post :like
    end
  end

  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register', edit: 'profile' }
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

  get '/about-me', to: 'pages#about'
  get '/tech-news', to: 'pages#tech_news'

  mount ActionCable.server => '/cable'

  root to: 'pages#home'
end
