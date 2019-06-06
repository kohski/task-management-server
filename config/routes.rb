Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'auth/registrations'
      }
    end
  end

  post 'image_file/upload'
  namespace :api do
    namespace :v1 do
      resources :groups, only:[:create, :destroy, :update, :show, :index]
    end
  end
  namespace :api do
    namespace :v1 do
      resources :assigns, only:[:create, :destroy]
    end
  end
  namespace :api do
    namespace :v1 do
      resources :jobs, only:[:create, :destroy, :update, :show, :index]
    end
  end
  namespace :api do
    namespace :v1 do
      resources :steps, only:[:create, :destroy, :update, :show, :index]
    end
  end

  namespace :api do
    namespace :v1 do
      resources :favorites, only:[:create, :destroy]
    end
  end

end
