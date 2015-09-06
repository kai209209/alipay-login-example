Rails.application.routes.draw do
  resource :user, only: :show
  devise_for :users
  root 'static#index'
end
