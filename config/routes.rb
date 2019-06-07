# frozen_string_literal: true

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
      resources :groups, only: %i[create destroy update show index]
    end
  end
  namespace :api do
    namespace :v1 do
      resources :assigns, only: %i[create destroy]
    end
  end
  namespace :api do
    namespace :v1 do
      resources :jobs, only: %i[create destroy update show index] do
        collection do
          get :public_jobs
        end
      end
    end
  end
  namespace :api do
    namespace :v1 do
      resources :steps, only: %i[create destroy update show index]
    end
  end

  namespace :api do
    namespace :v1 do
      resources :favorites, only: %i[create destroy]
    end
  end

  namespace :api do
    namespace :v1 do
      resources :job_tags, only: %i[create destroy]
    end
  end

  namespace :api do
    namespace :v1 do
      resources :tags, only: %i[create destroy index]
    end
  end
end
