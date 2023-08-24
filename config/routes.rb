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
    end
  end
end
