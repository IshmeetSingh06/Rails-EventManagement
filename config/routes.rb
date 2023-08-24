Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :index] do
        collection do
          get :list_events
          post :register
          put :update
        end

        member do
          put :deactivate
        end
      end

      resources :events, only: [:create, :index] do
        collection do
          get :list_all_organized
        end

        member do
          put :update
          put :cancel
        end
      end
    end
  end
end
