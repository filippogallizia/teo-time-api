Rails.application.routes.draw do

  scope defaults: { format: :json } do
    devise_for :users
    devise_for :trainers
  end

  get "/test/new", to: 'test#yo'
  mount TeoTime::API => '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
