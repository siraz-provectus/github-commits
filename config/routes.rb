Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  post :upload_commits, to: 'github#upload_commits'
  resources :commits, only: [:index]
  resources :users, only: [:edit, :update]
end
