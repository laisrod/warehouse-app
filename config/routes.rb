Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
    resources :warehouses, only: [:show, :new, :create, :edit, :update, :destroy]
    resources :suppliers, only: [:index, :show, :new, :create, :edit, :update]

    resources :orders do
      get 'search', on: :collection
      patch :delivered, on: :member
    end

  authenticate :user do
    resources :product_models, only: [:index, :new, :create, :show]
  end
end
