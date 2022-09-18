Rails.application.routes.draw do
  scope defaults: { format: :json } do
    devise_for :trainers, controllers: {
      sessions: 'users/sessions'
    }
    devise_for :users, controllers: {
      sessions: 'users/sessions'
    }
  end
  mount TeoTime::API => '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
