Goalsetter::Application.routes.draw do
  resources :users, only: [:new, :create, :show, :destroy, :index]
  resource :session, only: [:new, :create, :destroy]

  resources :goals, except: :show do
    member do
      post 'complete', to: 'goals#complete'
    end
  end

end
