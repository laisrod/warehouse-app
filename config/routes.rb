Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
    resources :warehouses, only: [:show, :new, :create, :edit, :update, :destroy]
    resources :suppliers, only: [:index, :show, :new, :create, :edit, :update]
    resources :product_models, only: [:index, :new, :create, :show]

    resources :orders, only: [:index, :show, :new, :create, :edit, :update] do

      resources :order_items, only: [:new, :create]

      get 'search', on: :collection
      post 'delivered', on: :member
      post 'cancel', on: :member
    end

    authenticate :user do
      resources :product_models, only: [:index, :new, :create, :show]
    end
end
