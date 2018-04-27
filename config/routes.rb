Rails.application.routes.draw do

  resources :icons
  resources :iconsets
  resources :places
  resources :layers
  resources :maps
  resources :groups
  devise_for :users
  root 'start#index'
  match 'preferences' => 'preferences#edit', :as => :preferences, via: [:get, :patch]

  get "bomb",        to: "application#bomb"
  post "report_csp", to: 'application#report_csp'

  # profile
  get   'edit_profile',    to: "start#edit_profile"
  patch 'update_profile',  to: "start#update_profile"


  namespace :admin do
    resources :users
  end

end
