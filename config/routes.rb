Rails.application.routes.draw do

  resources :groups
  devise_for :users

  root 'maps#index'

  match 'preferences' => 'preferences#edit', :as => :preferences, via: [:get, :patch]

  get "bomb",        to: "application#bomb"
  post "report_csp", to: 'application#report_csp'

  # profile
  get   'edit_profile',    to: "start#edit_profile"
  patch 'update_profile',  to: "start#update_profile"

  resources :iconsets
  resources :icons
  resources :maps do
    resources :layers do
      resources :places
    end
  end

  namespace :admin do
    resources :users
  end

end
