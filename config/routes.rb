numeric = lambda do |sym|
  { sym => /\d+/ }
end

Rails.application.routes.draw do
  devise_for :admins, controllers: { registrations: 'admins/registrations' }
  get "/admin", to: redirect("/admins/sign_in")
  get '/admins/sign_up', to: redirect('/')
  resources :stories do
    resources :pages, shallow: true
  end
  resources :tags, only: [:index, :destroy]
  resources :blog_posts

  get ":story/archive", to: "stories#contents", as: :story_contents
  get "/archive", to: "stories#contents", as: :contents
  
  root to: 'stories#home'
  get "/:page",               to: "stories#read", as: :read_page, constraints: numeric[:page]
  get "/:story_or_tag",       to: "stories#read", as: :read_story
  get "/:story_or_tag/:page", to: "stories#read", as: :read_story_page, constraints: numeric[:page]
  get "/:story/:tag",         to: "stories#read_story_tag", as: :read_story_tag
  get "/:story/:tag/:page",   to: "stories#read_story_tag", as: :read_story_tag_page, constraints: numeric[:page]

  # get "/rss", to: "pages#rss", as: :rss
end
