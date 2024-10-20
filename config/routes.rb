Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
    resources :warehouses, only: [:show, :new, :create, :edit, :update, :destroy]
    resources :suppliers, only: [:index, :show, :new, :create, :edit, :update]

  authenticate :user do
    resources :product_models, only: [:index, :new, :create, :show]
  end
end
