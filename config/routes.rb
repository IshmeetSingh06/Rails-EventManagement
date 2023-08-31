Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :index] do
        collection do
          get :events
          post :attend_event
          put :update
        end

        member do
          put :deactivate
        end
      end

      resources :events, only: [:create, :index] do
        collection do
          get :organized
          get :upcoming
        end

        member do
          put :update
          put :cancel
          get :registrations
        end
      end
    end
  end
end
