Rails.application.routes.draw do
  resource :user, only: :show
  devise_for :users, controllers: { sessions: "users/sessions" }
  devise_scope :user do
    get 'alipay_login', to: redirect(User.redirect_to_alipay_login_gateway)
    get 'sign_from_alipay', to: 'users/sessions#sign_from_alipay'
  end
  root 'static#index'
end
