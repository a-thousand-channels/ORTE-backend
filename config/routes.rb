Rails.application.routes.draw do

  devise_for :users

  root 'start#index'
  
  get "info", to: "start#info"

  match 'preferences' => 'preferences#edit', :as => :preferences, via: [:get, :patch]

  get "bomb",        to: "application#bomb"
  post "report_csp", to: 'application#report_csp'

  # profile
  get   'edit_profile',    to: "start#edit_profile"
  patch 'update_profile',  to: "start#update_profile"

  resources :iconsets do
    resources :icons
  end
  resources :maps do
    resources :layers do
      resources :places
    end
  end

  namespace :admin do
    resources :users
    resources :groups
  end

  namespace :public do
    resources :maps, only: [:show, :index], :defaults => { :format => :json }
  end

end
