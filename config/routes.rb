Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }
  resources :portfolios, except: [:show] do
    put :sort, on: :collection
  end
  get 'portfolio/:id', to: 'portfolios#show', as: 'portfolio_show'
  get 'portfolios/angulars', to: 'portfolios#angular', as: 'portfolio_angular'

  resources :blogs do
    member do
      get :toggle_status
    end
  end

  get '/about-me', to: 'pages#about'
  get '/contact', to: 'pages#contact'
  get '/tech-news', to: 'pages#tech_news'

  root to: 'pages#home'
end
