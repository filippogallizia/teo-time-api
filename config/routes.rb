Rails.application.routes.draw do

  scope defaults: { format: :json } do
    devise_for :users, controllers: {
      sessions: 'users/sessions',
      passwords: 'users/passwords'
    }
    devise_scope :user do
      get 'users/me', to: 'users/sessions#me'
      get 'users', to: 'users/sessions#list'

    end
  end

  mount TeoTime::API => '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
