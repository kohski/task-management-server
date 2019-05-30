Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'auth/registrations'
  }
  post 'image_file/upload'
  namespace :api do
    namespace :v1 do
      resources :groups, only:[:create, :destroy, :update, :show]
    end
  end

  namespace :api do
    namespace :v1 do
      resources :assigns, only:[:create, :destroy]
    end
  end


end
