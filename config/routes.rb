Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :boards do
    get :grid, on: :member
    resources :players do
      resources :picks
    end
  end
  root 'boards#index'
end
