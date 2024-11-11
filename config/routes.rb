Rails.application.routes.draw do
  # get "calendar/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root to: redirect("login/index")
  get "login/index", to: "login#index", as: "login"
  post "/logout", to: "sessions#logout", as: "logout"
  get "/auth/google_oauth2/callback", to: "sessions#omniauth"
  get "sessions/logout"
  get "sessions/omniauth"

  resources :admins
  get "welcome/index", to: "welcome#index", as: "welcome"
  get "welcome/download", to: "download#download", as: "download"
  post "uploads", to: "uploads#handle_upload", as: "uploads"
  # resources :uploads, only: [ :new, :create ]

  resources :calendar, only: [:index] do
    get :export, on: :collection
    get :download_unassigned_rjs, on: :collection
  end

  get "calendar", to: "calendar#index"

  # Route for deleting CSV
  delete "welcome/delete_csv_files", to: "welcome#delete_csv_files", as: "delete_csv_files"
  post "welcome/handle_files", to: "welcome#handle_files", as: "handle_files"
end
