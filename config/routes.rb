Rails.application.routes.draw do
  devise_for :admins, controllers: { registrations: 'admins/registrations' }
  get "/admin", to: redirect("/admins/sign_in")
  get '/admins/sign_up', to: redirect('/')
  resources :stories do
    resources :pages, shallow: true
  end
  resources :blog_posts
  
  root to: 'stories#read'
  get "/:story_link", to: "stories#read", as: :read_story
  get "/:story_link/:page", to: "stories#read", as: :read_story_page, constraints: { page: /\d+/ }
end
